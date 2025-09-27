include $(TOPDIR)/rules.mk

PROFILE_DESCRIPTION:=Generic metapackage for 8MB flash and/or 64MB RAM devices
PROFILE_DEPENDS:=+batctl-default \
	+check-date-http \
  +lime-debug \
	+lime-docs-minimal \
	+lime-proto-anygw \
	+lime-proto-babeld \
	+lime-proto-batadv \
	+owut \
	+prometheus-node-exporter-lua \
	+prometheus-node-exporter-lua-openwrt \
	+prometheus-node-exporter-lua-wifi \
	+prometheus-node-exporter-lua-wifi_stations \
	+shared-state \
	+shared-state-babeld_hosts \
	+shared-state-nodes_and_links

include ../../profile.mk

# call BuildPackage - OpenWrt buildroot signature
