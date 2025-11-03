include $(TOPDIR)/rules.mk

PROFILE_NAME=$(notdir ${CURDIR})
PROFILE_COMMUNITY=$(lastword $(filter-out $(PROFILE_NAME),$(subst /, ,$(CURDIR))))
PKG_NAME:=profile-$(PROFILE_COMMUNITY)-$(PROFILE_NAME)

PROFILE_DESCRIPTION:=lime-owut
PROFILE_DEPENDS:=+owut

define Package/$(PKG_NAME)/postinst
#!/bin/sh
# Backup opkg status before cleaning if CONFIG_CLEAN_IPKG=y
grep -q CONFIG_CLEAN_IPKG=y $${TOPDIR}/.config || exit 0

cp $${IPKG_INSTROOT}/usr/lib/opkg/status $${IPKG_INSTROOT}/etc/opkg/
cat << EOF >> $${IPKG_INSTROOT}/etc/uci-defaults/99_owut-packagelist
#!/bin/sh
rm /usr/lib/opkg/status
ln -s /etc/opkg/status /usr/lib/opkg/status
EOF
endef

include ../../profile.mk

# call BuildPackage - OpenWrt buildroot signature
