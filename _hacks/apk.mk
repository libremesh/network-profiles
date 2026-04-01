include $(TOPDIR)/rules.mk

PROFILE_NAME=$(notdir ${CURDIR})
PROFILE_COMMUNITY=$(lastword $(filter-out $(PROFILE_NAME),$(subst /, ,$(CURDIR))))
PKG_NAME:=profile-$(PROFILE_COMMUNITY)-$(PROFILE_NAME)

define Package/$(PKG_NAME)/postinst
#!/bin/bash

echo "INSIDE PACKAGE $(PKG_NAME) POSTINST"
grep -q IB_MODIFIED_BY_$(PKG_NAME)_postinst $${TOPDIR}/Makefile && exit 0
echo "########################################################################## Backup original files"
cp $${TOPDIR}/Makefile $${TOPDIR}/Makefile.orig

echo "########################################################################## Determine make's target"
cmdline_args=$$(cat /proc/*/cmdline 2>/dev/null | tr -d '\0' | head -n 1)
make_target=$$(echo "$${cmdline_args}" | grep -q makemanifest && echo 'manifest' || echo 'image')

echo "make_target: $${make_target}"

cat << EOF >> $${TOPDIR}/Makefile
echo_build_packages:
	@echo BUILD_PACKAGES
EOF

sed -i 's|@echo BUILD_PACKAGES|@echo $\$$(BUILD_PACKAGES)|' $${TOPDIR}/Makefile

build_packages=$$(cd $${TOPDIR}; make echo_build_packages)
echo "Build packages: $${build_packages}"

need_rerun=0

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

echo "# IB_MODIFIED_BY_$(PKG_NAME)_postinst" >> $${TOPDIR}/Makefile

if [ $${need_rerun} = 1 ]; then
	echo "########################################################################## Re-run make $${make_target} with the untouched MAKEFLAGS"
	cd $${TOPDIR}
	make $${make_target}
	#make fail_target
	mv $${TOPDIR}/Makefile.orig $${TOPDIR}/Makefile
	kill $$(pidof make)
else
	mv $${TOPDIR}/Makefile.orig $${TOPDIR}/Makefile
fi
exit 0
endef
