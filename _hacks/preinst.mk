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

ifneq ($(PKG_CONFIGS),)
include ../../_hacks/_preinst_pkg_configs.mk
endif

ifneq ($(PKG_CONFLICTS),)
include ../../_hacks/_preinst_pkg_conflicts.mk
endif
