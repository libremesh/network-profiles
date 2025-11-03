define Package/$(PKG_NAME)/postinst
#!/bin/bash
# Run only in imagebuilder/sdk, exit if executed on the target device or buildroot
[ -z "$${IPKG_INSTROOT}" ] && exit 0
[ -f "$${TOPDIR}/version" ] && exit 0
grep -q IB_MODIFIED_BY_$(PKG_NAME)_preinst $${TOPDIR}/Makefile || exit 0
echo "########################################################################## Inside package $(PKG_NAME) postinst"

endef
