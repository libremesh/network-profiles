include $(TOPDIR)/rules.mk

PROFILE_DESCRIPTION:=Encryptable mesh and AP for Calafou indoor nodes
PROFILE_DEPENDS:=+deferable-reboot +safe-reboot +wpad-full-openssl \
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
	+babeld-auto-gw-mode

include ../../profile.mk

# call BuildPackage - OpenWrt buildroot signature
