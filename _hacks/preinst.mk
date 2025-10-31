include $(TOPDIR)/rules.mk

PROFILE_NAME=$(notdir ${CURDIR})
PROFILE_COMMUNITY=$(lastword $(filter-out $(PROFILE_NAME),$(subst /, ,$(CURDIR))))
PKG_NAME:=profile-$(PROFILE_COMMUNITY)-$(PROFILE_NAME)

define Package/$(PKG_NAME)/preinst
#!/bin/bash
[ -z "$${IPKG_INSTROOT}" ] && exit 0
[ -f "$${TOPDIR}/version" ] && exit 0
grep -q IB_MODIFIED_BY_$(PKG_NAME) $${TOPDIR}/Makefile && exit 0
echo "########################################################################## Inside package $(PKG_NAME) preinst"
echo "########################################################################## Backup original files"
cp $${TOPDIR}/Makefile $${TOPDIR}/Makefile.orig
cp $${TOPDIR}/.config $${TOPDIR}/.config.orig
echo "########################################################################## Determine make's target"
cmdline_args=$$(cat /proc/*/cmdline | tr -d '\0' | head -n 1)
make_target=$$(echo "$${cmdline_args}" | grep -q makemanifest && echo 'manifest' || echo 'image')
echo "make_target: $${make_target}"

if [ -n "$(PKG_CONFIGS)" ]; then
$(Package/$(PKG_NAME)/preinst_pkg_configs)
fi
if [ -n "$(PKG_CONFLICTS)" ]; then
$(Package/$(PKG_NAME)/preinst_pkg_conflicts)
fi

echo "########################################################################## Add a target that restore original files and kill parent process"
cat << EOF >> $${TOPDIR}/Makefile
fail_target:
	mv $${TOPDIR}/Makefile.orig $${TOPDIR}/Makefile
	mv $${TOPDIR}/.config.orig $${TOPDIR}/.config
	kill $$(ls -l /proc/*/exe | grep make | sed 's|.*/proc/\(.*\)/exe.*|\1|' | tr '\n' ' ' )
# IB_MODIFIED_BY_$(PKG_NAME)
EOF

if [ $${need_rerun} = 1 ]; then
	echo "########################################################################## Re-run make ${make_target} with the untouched MAKEFLAGS"
	make $${make_target}
	make fail_target
else
	echo "########################################################################## Restore original files and continue build without hack"
	mv $${TOPDIR}/Makefile.orig $${TOPDIR}/Makefile
	mv $${TOPDIR}/.config.orig $${TOPDIR}/.config
	exit 0
fi
endef

ifneq ($(PKG_CONFIGS),)
include ../../_hacks/_pkg_configs.mk
endif

ifneq ($(PKG_CONFLICTS),)
include ../../_hacks/_pkg_conflicts.mk
endif
