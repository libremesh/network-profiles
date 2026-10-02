include $(TOPDIR)/rules.mk

# Cfr. https://github.com/libremesh/network-profiles/pull/99
# This package extends the list of libremesh suggested packages adding:
# - lime-hwd-watchcat (a useful ping-watchdog utility)
# - lime-owut (simplified upgrades from within the device using an online IB)
# - pirania (captive portal and voucher system/manager)
# - px5g-standalone (lime-app with https, use instead luci-ssl-openssl if you prefer luci)
# - all shared-state-async plugins
# - all shared-state plugins
# - wpad-mesh-openssl (for encrypted mesh connections)
# - openssl variants of default packages (-apk-mbedtls, -libustream-mbedtls, -wpad-basic-mbedtls)

PROFILE_DESCRIPTION:=A more extensive list of suggested LibreMesh packages.\
	Default openwrt's packages to manually remove are: \
		-apk-mbedtls \
		-dnsmasq \
		-libustream-mbedtls \
		-odhcpd-ipv6only \
		-wpad-basic-mbedtls
PROFILE_DEPENDS:=\
	+apk-openssl \
	+libustream-openssl \
	+lime-hwd-watchcat \
	+lime-owut \
	+pirania \
	+profile-libremesh-suggested-packages \
	+px5g-standalone \
	+shared-state-babel_links_info \
	+shared-state-bat_links_info \
	+shared-state-dnsmasq_servers \
	+shared-state-network_nodes \
	+shared-state-node_info \
	+shared-state-wifi_links_info \
	+wpad-mesh-openssl

include ../../profile.mk

# call BuildPackage - OpenWrt buildroot signature
