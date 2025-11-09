include $(TOPDIR)/rules.mk

PROFILE_DESCRIPTION:=Generic metapackage for 8MB flash and/or 64MB RAM devices
PKG_CONFLICTS:=\
	-apk-mbedtls \
	-batctl-tiny \
	-ca-bundle \
	-dnsmasq \
	-odhcpd-ipv6only \
	-opkg \
	-ppp \
	-ppp-mod-pppoe
PKG_CONFIGS:=\
	CONFIG_CLEAN_IPKG=y
PROFILE_DEPENDS:=\
	+batctl-default \
	+babeld-auto-gw-mode \
	+check-date-http \
	+lime-docs-minimal \
	+lime-hwd-openwrt-wan \
	+lime-proto-anygw \
	+lime-proto-babeld \
	+lime-proto-batadv \
	+shared-state \
	+shared-state-babeld_hosts \
	+shared-state-nodes_and_links

include ../../_hacks/index.mk
include ../../profile.mk

# call BuildPackage - OpenWrt buildroot signature
