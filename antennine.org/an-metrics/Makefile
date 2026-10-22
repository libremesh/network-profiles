include $(TOPDIR)/rules.mk

PROFILE_DESCRIPTION:=Prometheus collectors and script to push to a pushgateway server. Can be installed on a plain OpenWrt.
PROFILE_DEPENDS:=\
	+prometheus-node-exporter-ucode \
	+prometheus-node-exporter-ucode-openwrt

include ../../profile.mk

# call BuildPackage - OpenWrt buildroot signature
