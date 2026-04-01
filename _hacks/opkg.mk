include $(TOPDIR)/rules.mk

PROFILE_NAME=$(notdir ${CURDIR})
PROFILE_COMMUNITY=$(lastword $(filter-out $(PROFILE_NAME),$(subst /, ,$(CURDIR))))
PKG_NAME:=profile-$(PROFILE_COMMUNITY)-$(PROFILE_NAME)

define Package/$(PKG_NAME)/preinst
#!/bin/bash
# Run only in imagebuilder/sdk, exit if executed on the target device or buildroot
[ -z "$${IPKG_INSTROOT}" ] && exit 0
[ -f "$${TOPDIR}/version" ] && exit 0
grep -q IB_MODIFIED_BY_$(PKG_NAME)_preinst $${TOPDIR}/Makefile && exit 0
echo "########################################################################## Inside package $(PKG_NAME) preinst"
echo "########################################################################## Backup original files"
cp $${TOPDIR}/Makefile $${TOPDIR}/Makefile.orig
cp $${TOPDIR}/.config $${TOPDIR}/.config.orig
cp $${TOPDIR}/include/rootfs.mk $${TOPDIR}/include/rootfs.mk.orig

echo "########################################################################## Ensure postinst-pkg are executed"
sed -i 's|\(IPKG_POSTINST_PATH=\).*|\1./usr/lib/opkg/info/\*\.postinst\*; \\|' $${TOPDIR}/include/rootfs.mk

echo "########################################################################## Determine make's target"
cmdline_args=$$(cat /proc/*/cmdline | tr -d '\0' | head -n 1)
make_target=$$(echo "$${cmdline_args}" | grep -q makemanifest && echo 'manifest' || echo 'image')
echo "make_target: $${make_target}"

echo "########################################################################## Check if a re-run is needed"
need_rerun=0

if [ -n "$(PKG_CONFIGS)" ]; then
$(Package/$(PKG_NAME)/preinst_pkg_configs)
echo "########################################################################## pkg_configs: end"
fi

if [ -n "$(PKG_CONFLICTS)" ]; then
$(Package/$(PKG_NAME)/preinst_pkg_conflicts)
echo "########################################################################## pkg_conflicts: end"
fi


echo "########################################################################## Add a target that restore original files and kill parent process"
cat << EOF >> $${TOPDIR}/Makefile
fail_target:
	mv $${TOPDIR}/Makefile.orig $${TOPDIR}/Makefile
	mv $${TOPDIR}/.config.orig $${TOPDIR}/.config
	mv $${TOPDIR}/include/rootfs.mk.orig $${TOPDIR}/include/rootfs.mk
	kill $$(ls -l /proc/*/exe | grep make | sed 's|.*/proc/\(.*\)/exe.*|\1|' | tr '\n' ' ' )
# IB_MODIFIED_BY_$(PKG_NAME)_preinst
EOF

if [ $${need_rerun} = 1 ]; then
	echo "########################################################################## Re-run make $${make_target} with the untouched MAKEFLAGS"
	make $${make_target} 
	make fail_target
else
	echo "########################################################################## Restore original files and continue build without hack"
	mv $${TOPDIR}/Makefile.orig $${TOPDIR}/Makefile 2>/dev/null
	mv $${TOPDIR}/.config.orig $${TOPDIR}/.config 2>/dev/null
	mv $${TOPDIR}/include/rootfs.mk.orig $${TOPDIR}/include/rootfs.mk 2>/dev/null
fi

endef


# hack to define/modify configs among those evaluated by the imagebuilder
define Package/$(PKG_NAME)/preinst_pkg_configs
for config in "$(PKG_CONFIGS)"; do
	grep -q "$${config}" $${TOPDIR}/.config && continue
	need_rerun=1
	if [ "$${config:0:1}" = '#' ]; then
		sed -i "s|$${config:2:-11}=y|$${config}|" $${TOPDIR}/.config
	else
		config_name="$$(echo $${config} | cut -d '=' -f 1)"
		sed -i "s|# $${config_name} is not set|$${config}|" $${TOPDIR}/.config
	fi
done
endef

# hack to deselect openwrt's default_packages. To be used by at most by one metapackage/network-profile
define Package/$(PKG_NAME)/preinst_pkg_conflicts
echo "########################################################################## pkg_conflicts: Check default packages"
cat << EOF >> $${TOPDIR}/Makefile
echo_build_packages:
	@echo BUILD_PACKAGES
EOF
sed -i 's|@echo BUILD_PACKAGES|@echo $\$$(BUILD_PACKAGES)|' $${TOPDIR}/Makefile
build_packages=$$(make echo_build_packages)
echo "Build packages: $${build_packages}"

echo "########################################################################## pkg_conflicts: Exit if no changes needed"
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
		need_rerun=1
		break
	fi
	echo 'Unset continuing'
done

echo "########################################################################## pkg_conflicts: Add PKG_CONFLICTS to be removed in the main Makefile"
sed -i 's|\($$(USER_PACKAGES)\) \($$(BUILD_PACKAGES)\)|\1 $(PKG_CONFLICTS) \2|' $${TOPDIR}/Makefile
echo "########################################################################## pkg_conflicts: Prevent unnecessary opkg/apk update in the main Makefile"
sed -i '/update/d' $${TOPDIR}/Makefile
if [ "$${make_target}" = "manifest" ]; then
	echo "########################################################################## pkg_conflicts: make manifest: use the BIN_DIR of asu if available"
	manifest_dir=$$(find $${TOPDIR} -maxdepth 1 -type d -regex '.*[a-z].*[0-9].*' | grep . || echo $${TOPDIR}/bin/targets/$${TARGET} )
	mkdir -p "$${manifest_dir}"
	sed -i "s|\(--manifest --no-network\)|\1 > $${manifest_dir}/manifest|" $${TOPDIR}/Makefile
	sed -i "s|\(--strip-abi)\)|\1 > $${manifest_dir}/manifest|" $${TOPDIR}/Makefile
fi
endef
