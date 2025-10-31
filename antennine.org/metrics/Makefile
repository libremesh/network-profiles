include $(TOPDIR)/rules.mk

PROFILE_NAME:=$(notdir ${CURDIR})
PROFILE_DESCRIPTION:=Prometheus collectors and script to push to a pushgateway server
PROFILE_DEPENDS:=\
	+prometheus-node-exporter-lua \
	+prometheus-node-exporter-lua-location-latlon \
	+prometheus-node-exporter-lua-openwrt \
	+prometheus-node-exporter-lua-wifi \
	+prometheus-node-exporter-lua-wifi_stations

include ../../profile.mk

# call BuildPackage - OpenWrt buildroot signature
