include $(TOPDIR)/rules.mk

PROFILE_DESCRIPTION:=Encryptable mesh and AP for Calafou outdoor node used as a gateway
PROFILE_DEPENDS:=+deferable-reboot +safe-reboot +wpad-openssl +shared-state-network_nodes +shared-state-dnsmasq_servers \
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
	+prometheus-node-exporter-lua \
	+prometheus-node-exporter-lua-openwrt \
	+prometheus-node-exporter-lua-wifi_stations \
	+prometheus-node-exporter-lua-wifi-stations-extra \
	+prometheus-node-exporter-lua-wifi-survey \
	+prometheus-node-exporter-lua-wifi-params \
	+prometheus-node-exporter-lua-location-latlon


include ../../profile.mk

# call BuildPackage - OpenWrt buildroot signature
