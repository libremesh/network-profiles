include $(TOPDIR)/rules.mk

PROFILE_DESCRIPTION:=Network used for Iberic Hackmeeting 2019 in Errekaleor
PROFILE_DEPENDS:=+prometheus-node-exporter-lua \
+prometheus-node-exporter-lua-wifi             \
+prometheus-node-exporter-lua-wifi_stations    \
+prometheus-node-exporter-lua-openwrt          \
+lime-system                                   \
+lime-proto-babeld                             \
+lime-proto-batadv                             \
+lime-proto-anygw                              \
+lime-proto-wan                                \
+lime-hwd-openwrt-wan                          \
+shared-state                                  \
+hotplug-initd-services                        \
+shared-state-babeld_hosts                     \
+shared-state-bat_hosts                        \
+shared-state-dnsmasq_hosts                    \
+shared-state-dnsmasq_leases                   \
+shared-state-nodes_and_links                  \
+check-date-http                               \
+lime-app                                      \
+lime-docs-minimal                             \
+first-boot-wizard                             \
+lime-map-agent                                \
+lime-docs                                     \
+lime-hwd-ground-routing                       \
+lime-debug                                    \
+ubus-lime-batman-adv                          \
+ubus-lime-fbw                                 \
+pirania                                       \
+pirania-app                                   \
+shared-state-pirania                          \
+shared-state-persist

include ../../profile.mk

# call BuildPackage - OpenWrt buildroot signature
