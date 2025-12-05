include $(TOPDIR)/rules.mk

PROFILE_DESCRIPTION:=Generic package with authorized_keys and lime files

PROFILE_NAME=$(notdir ${CURDIR})
PROFILE_COMMUNITY=$(lastword $(filter-out $(PROFILE_NAME),$(subst /, ,$(CURDIR))))
PKG_NAME:=profile-$(PROFILE_COMMUNITY)-$(PROFILE_NAME)

define Package/$(PKG_NAME)/postinst
#!/bin/sh
[ -z "$${IPKG_INSTROOT}" ] && exit 0

# Disable dropbear password authentication
sed -i "s|\(PasswordAuth\).*|\1\ 'off'|g" $${IPKG_INSTROOT}/etc/config/dropbear

# Fix dropbear authorized keys permissions
chmod 0600 $${IPKG_INSTROOT}/etc/dropbear/authorized_keys
chmod 0700 $${IPKG_INSTROOT}/etc/dropbear
endef

include ../../profile.mk

# call BuildPackage - OpenWrt buildroot signature
