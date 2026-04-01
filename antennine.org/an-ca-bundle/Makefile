include $(TOPDIR)/rules.mk

PROFILE_NAME=$(notdir ${CURDIR})
PROFILE_COMMUNITY=$(lastword $(filter-out $(PROFILE_NAME),$(subst /, ,$(CURDIR))))
PKG_NAME:=profile-$(PROFILE_COMMUNITY)-$(PROFILE_NAME)

PKG_CA_CERTS_URLS:=\
	https://letsencrypt.org/certs/isrgrootx1.pem \
	https://letsencrypt.org/certs/isrg-root-x2.pem

OW_BRANCH:=$(shell echo $$(grep -m1 -o "releases/.*" $(TOPDIR)/include/version.mk \
	|| echo "main") | cut -d"/" -f2 | cut -d"-" -f1 | cut -d"." -f1,2)
ifneq ($(OW_BRANCH),main)
ifeq ($(shell test $$(echo "$(OW_BRANCH)" | cut -d"." -f1) -lt 25; echo $$?),0)
define Package/$(PKG_NAME)/preinst
$(Package/$(PKG_NAME)/add_ca_certs)
endef
else
define Package/$(PKG_NAME)/postinst
$(Package/$(PKG_NAME)/add_ca_certs)
endef
endif

else
define Package/$(PKG_NAME)/postinst
$(Package/$(PKG_NAME)/add_ca_certs)
endef
endif

define Package/$(PKG_NAME)/add_ca_certs
	[ -z "$${IPKG_INSTROOT}" ] && exit 0
	$(INSTALL_DIR) $${IPKG_INSTROOT}/etc/ssl/certs
	for ca_cert_url in $(PKG_CA_CERTS_URLS); do
		wget -q "$${ca_cert_url}" -O - >> $${IPKG_INSTROOT}/etc/ssl/certs/ca-certificates.crt
	done
	$(LN) /etc/ssl/certs/ca-certificates.crt $${IPKG_INSTROOT}/etc/ssl/cert.pem
endef

include ../../profile.mk

# call BuildPackage - OpenWrt buildroot signature
