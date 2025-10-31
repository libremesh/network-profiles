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
echo "########################################################################## Prevent unnecessary opkg/apk update in the main Makefile"
sed -i '/update/d' $${TOPDIR}/Makefile
if [ "$${make_target}" = "manifest" ]; then
	echo "########################################################################## pkg_conflicts: make manifest: use the BIN_DIR of asu if available"
	manifest_dir=$$(find $${TOPDIR} -maxdepth 1 -type d -regex '.*[a-z].*[0-9].*' | grep . || echo $${TOPDIR}/bin/targets/$${TARGET} )
	mkdir -p "$${manifest_dir}"
	sed -i "s|\(--manifest --no-network\)|\1 > $${manifest_dir}/manifest|" $${TOPDIR}/Makefile
	sed -i "s|\(--strip-abi)\)|\1 > $${manifest_dir}/manifest|" $${TOPDIR}/Makefile
fi
endef
