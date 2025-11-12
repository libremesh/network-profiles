include $(TOPDIR)/rules.mk

PROFILE_DESCRIPTION:=Prometheus collectors and script to push to a pushgateway server
PROFILE_DEPENDS:=\
	+coreutils-base64 \
	+prometheus-node-exporter-lua \
	+prometheus-node-exporter-lua-openwrt \
	+prometheus-node-exporter-lua-wifi \
	+prometheus-node-exporter-lua-wifi_stations \
	+prometheus-node-exporter-lua-location-latlon

include ../../profile.mk

# call BuildPackage - OpenWrt buildroot signature
