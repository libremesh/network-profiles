include $(TOPDIR)/rules.mk

PROFILE_DESCRIPTION:=Firmware to use in a workshop presenting LibreMesh in BattleMesh v17 in Sundhausen
PROFILE_DEPENDS:=+shared-state-network_nodes +shared-state-dnsmasq_servers \
	+lime-docs \
	+lime-proto-babeld \
	+lime-proto-batadv \
	+lime-proto-anygw \
	+lime-hwd-openwrt-wan \
	+shared-state \
	+hotplug-initd-services \
	+shared-state-babeld_hosts \
	+shared-state-bat_hosts \
	+shared-state-dnsmasq_hosts \
	+shared-state-dnsmasq_leases \
	+shared-state-nodes_and_links \
	+check-date-http \
	+lime-app \
	+lime-hwd-ground-routing \
	+lime-debug \
	+babeld-auto-gw-mode \
	+px5g-standalone

include ../../profile.mk

# call BuildPackage - OpenWrt buildroot signature
