include $(TOPDIR)/rules.mk

PROFILE_DESCRIPTION:=Generic valsamoggia configuration
PROFILE_DEPENDS:= +lime-proto-babeld \
	+lime-proto-batadv \
	+lime-proto-anygw \
	+lime-proto-wan \
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
	+luci 

include ../../profile.mk

# call BuildPackage - OpenWrt buildroot signature
