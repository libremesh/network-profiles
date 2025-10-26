include $(TOPDIR)/rules.mk

PROFILE_NAME=$(notdir ${CURDIR})
PROFILE_COMMUNITY=$(lastword $(filter-out $(PROFILE_NAME),$(subst /, ,$(CURDIR))))
PKG_NAME:=profile-$(PROFILE_COMMUNITY)-$(PROFILE_NAME)

# hack to deselect openwrt's default_packages. To be used by at most by one metapackage/network-profile
define Package/$(PKG_NAME)/postinst
#!/bin/sh
[ -z "$${IPKG_INSTROOT}" ] && exit 0
echo "########################################################################## Inside package $(PKG_NAME) preinst"
grep -q IB_MODIFIED_BY_$(PKG_NAME) $${TOPDIR}/Makefile && exit 0
echo "########################################################################## Backup original Makefile"
cp $${TOPDIR}/Makefile $${TOPDIR}/Makefile.orig
echo "########################################################################## Check default packages"
cat << EOF > /tmp/hack_pkg_conflicts
echo_build_packages:
	@echo BUILD_PACKAGES
EOF
cat /tmp/hack_pkg_conflicts >> $${TOPDIR}/Makefile
sed -i 's|@echo BUILD_PACKAGES|@echo $\$$(BUILD_PACKAGES)|' $${TOPDIR}/Makefile
build_packages=$$(make echo_build_packages)
echo "Build packages: $${build_packages}"
echo "########################################################################## Exit if no changes needed"
need_run=0
for p in $(PKG_CONFLICTS); do
  i=$$(echo $$p | sed 's|-||')
  echo "Verifing the removal of package: $${i}"
  present=$$(echo $$build_packages | sed 's|\s|\n|g' | grep $$i | grep -v "\-$$i" )
  removed=$$(echo $$build_packages | sed 's|\s|\n|g' | grep "\-$$i")
  if [ -n "$${removed}" ]; then
    echo "Removed continuing"
    continue;
  fi
  if [ -n "$${present}" ]; then
    echo "Present need_run"
    need_run=1
    break
  fi
  echo 'Unset continuing'
done
if [ $${need_run} = 0 ]; then
  echo "Continue build without hack"
  cp $${TOPDIR}/Makefile.orig $${TOPDIR}/Makefile
  exit 0
fi
echo "########################################################################## Determine make's target"
R=$$(for cmd in $$(ls -l /proc/*/exe | grep make | sed 's|.*/proc/\(.*\)/exe.*|\1|' | tr '\n' ' ' | tr -d '\0' ) ; do cat "/proc/$${cmd}/cmdline"; done)
make_target=$$(echo "$${R}" | grep -q makemanifest && echo 'manifest' || echo 'image')
echo "make_target: $${make_target}"
echo "########################################################################## Add PKG_CONFLICTS to be removed in the main Makefile"
sed -i 's|\($$(USER_PACKAGES)\) \($$(BUILD_PACKAGES)\)|\1 $(PKG_CONFLICTS) \2|' $${TOPDIR}/Makefile
echo "########################################################################## Prevent unnecessary opkg/apk update in the main Makefile"
sed -i '/update/d' $${TOPDIR}/Makefile
echo "########################################################################## Terminate the execution after the second make image/manifest"
cat << EOF > /tmp/hack_pkg_conflicts
fail_target:
	cp $${TOPDIR}/Makefile.orig $${TOPDIR}/Makefile
	rm /tmp/hack_pkg_conflicts $${TOPDIR}/Makefile.orig
	kill $$(ls -l /proc/*/exe | grep make | sed 's|.*/proc/\(.*\)/exe.*|\1|' | tr '\n' ' ' )
# IB_MODIFIED_BY_$(PKG_NAME)
EOF
cat /tmp/hack_pkg_conflicts >> $${TOPDIR}/Makefile 
echo "########################################################################## Re-run make $${make_target} with the untouched MAKEFLAGS"
if [ "$${make_target}" = "manifest" ]; then
  echo "########################################################################## make manifest: use the BIN_DIR of asu if available"
  manifest_dir=$$(find $${TOPDIR} -maxdepth 1 -type d -regex '.*[a-z].*[0-9].*' | grep . || echo $${TOPDIR}/bin/targets/$${TARGET} )
  mkdir -p "$${manifest_dir}"
  sed -i "s|\(--manifest --no-network\)|\1 > $${manifest_dir}/manifest|" $${TOPDIR}/Makefile
  sed -i "s|\(--strip-abi)\)|\1 > $${manifest_dir}/manifest|" $${TOPDIR}/Makefile
fi
make "$${make_target}"
make fail_target
endef
