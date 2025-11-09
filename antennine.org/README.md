# profile-antennine.org-an-*

Profiles in use in the network Antennine, Italy https://antennine.org

## prometheus configurations: profile-antennine.org-an-metrics

Example of required configuration when building via asu.
Replace pushgateway host, `<httpd_user>` and `<httpd_password>`.

/etc/uci-defaults/99-asu-defaults
```
uci -q batch <<EOF
set lime-node.pushgateway=lime
set lime-node.pushgateway.host='panorama.antennine.org/pushgateway'
set lime-node.pushgateway.user='<httpd_user>'
set lime-node.pushgateway.password='<httpd_password>'
commit lime-node
EOF
lime-config; lime-apply; wifi
```

## wireguard configurations
https://github.com/openwrt/openwrt/issues/13211#issuecomment-2504873753

Example of required configuration when building via asu.
Replace at least `<server_public_key>` `<endpoint_host>` `<endpoint_port>` 
`<client_private_key>` `<client_listen_port>`.

```
ipv4_host=$(uci get network.lan.ipaddr | sed 's|.*\.\(.*\..*\)|\1|')

uci -q batch << EOF
set network.wg1=interface
set network.wg1.proto='wireguard'
set network.globals.packet_steering='1'

add network wireguard_wg1
set network.@wireguard_wg1[0].description='Remote debug wg1'
set network.@wireguard_wg1[0].public_key='<server_public_key>'
add_list network.@wireguard_wg1[0].allowed_ips='192.168.0.0/16'
set network.@wireguard_wg1[0].persistent_keepalive='25'
set network.@wireguard_wg1[0].endpoint_host='<endpoint_host>'
set network.@wireguard_wg1[0].endpoint_port='<endpoint_port>'

set network.wg1.private_key='<client_private_key>'
set network.wg1.listen_port='<client_listen_port>'
add_list network.wg1.addresses='192.168.${ipv4_host}/16'
set network.wg1.nohostroute='1'

add network route
set network.@route[-1].interface='wg1'
set network.@route[-1].target='192.168.0.0/16'
commit network
EOF

lime-config; lime-apply; wifi
```