include $(TOPDIR)/rules.mk

PROFILE_DESCRIPTION:=Use 802.11s with SAE for mesh, route with batman-adv only
PROFILE_DEPENDS:+wpad-mesh-wolfssl +kmod-batman-adv +lime-proto-batadv +lime-proto-anyway +uhttpd-mod-lua +shared-state +shared-state-bat_hosts +shared-state-dnsmasq_hosts +shared-state-dnsmasq_leases

include ../../profile.mk

# call BuildPackage - OpenWrt buildroot signature
