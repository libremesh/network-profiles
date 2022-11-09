include $(TOPDIR)/rules.mk

PROFILE_DESCRIPTION:=Use 802.11s with SAE for mesh, route with batman-adv only
PROFILE_DEPENDS:=+wpad-mesh-wolfssl +lime-proto-batadv +lime-proto-anygw +shared-state +shared-state-bat_hosts +shared-state-dnsmasq_hosts +shared-state-dnsmasq_leases +wifi-unstuck-wa

include ../../profile.mk

# call BuildPackage - OpenWrt buildroot signature
