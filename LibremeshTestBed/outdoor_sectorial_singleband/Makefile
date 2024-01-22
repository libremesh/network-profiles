include $(TOPDIR)/rules.mk

PROFILE_DESCRIPTION:=Mesh and AP for Test Bed LibreMesh 2024 outdoor sectorial single band nodes
PROFILE_DEPENDS:=+lime-docs-minimal            \
+lime-debug
+lime-app                                      \
+lime-hwd-openwrt-wan                          \
+lime-proto-anygw                              \
+lime-proto-babeld                             \
+lime-proto-batadv                             \
+shared-state                                  \
+shared-state-babeld_hosts                     \
+shared-state-bat_hosts                        \
+shared-state-nodes_and_links                  \
+babeld-auto-gw-mode                           \
+batctl-default                                \
+check-date-http                               \
+lime-docs                                     \
+lime-hwd-ground-routing                       \
+lime-debug
	

include ../../profile.mk

# call BuildPackage - OpenWrt buildroot signature
