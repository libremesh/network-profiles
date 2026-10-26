include $(TOPDIR)/rules.mk

PROFILE_DESCRIPTION:=Generic metapackage for devices with at least 16MB flash and 128MB RAM
PKG_CONFLICTS:=\
	-ca-bundle
PROFILE_DEPENDS:=\
	+batctl-default \
	+babeld-auto-gw-mode \
	+check-date-http \
	+lime-debug \
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
