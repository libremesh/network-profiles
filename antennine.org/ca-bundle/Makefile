include $(TOPDIR)/rules.mk

PROFILE_NAME=$(notdir ${CURDIR})
PROFILE_COMMUNITY=$(lastword $(filter-out $(PROFILE_NAME),$(subst /, ,$(CURDIR))))
PKG_NAME:=profile-$(PROFILE_COMMUNITY)-$(PROFILE_NAME)

PKG_CA_CERTS_URLS:=\
	https://letsencrypt.org/certs/isrgrootx1.pem \
  https://letsencrypt.org/certs/isrg-root-x2.pem

define Package/$(PKG_NAME)/preinst
  [ -z "$${IPKG_INSTROOT}" ] && exit 0
  $(INSTALL_DIR) $${IPKG_INSTROOT}/etc/ssl/certs
  for ca_cert_url in $(PKG_CA_CERTS_URLS); do
    wget "$${ca_cert_url}" -O - >> $${IPKG_INSTROOT}/etc/ssl/certs/ca-certificates.crt
  done
  $(LN) /etc/ssl/certs/ca-certificates.crt $${IPKG_INSTROOT}/etc/ssl/cert.pem
endef

include ../../profile.mk

# call BuildPackage - OpenWrt buildroot signature
