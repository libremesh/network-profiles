include $(TOPDIR)/rules.mk

PROFILE_DESCRIPTION:=Tiny version of packages officially suggested on the LibreMesh.org website. Intended for 4/32 devices: suited for devices with ≤4MB Flash up to openwrt 19.07; suited for devices with ≤32MB RAM up to openwrt 22.03
PROFILE_DEPENDS:=+lime-hwd-openwrt-wan         \
+lime-proto-anygw                              \
+lime-proto-babeld                             \
+lime-proto-batadv                             \
+shared-state                                  \
+shared-state-babeld_hosts                     \
+lime-docs-minimal                             \
+babeld-auto-gw-mode

include ../../profile.mk

# call BuildPackage - OpenWrt buildroot signature
