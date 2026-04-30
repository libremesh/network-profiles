# profile-antennine.org-an-*

Profiles in use in the network Antennine, Italy https://antennine.org

Common uci-defaults script used with ASU (online imagebuilder) to configure:
- prometheus via the package `profile-antennine.org-an-metrics`
- wireguard installing `wireguard-tools`

/etc/uci-defaults/99-asu-defaults
```
hostname='LiMe-%M4%M5%M6'
domain='thisnode.info'
pushgateway_host='panorama.antennine.org/pushgateway'
pushgateway_user=''
pushgateway_password=''

uci -q batch <<EOF
set lime-node.system=lime
set lime-node.system.hostname='${hostname}'
set lime-node.system.domain='${domain}'
set lime-node.pushgateway=lime
set lime-node.pushgateway.host='${pushgateway_host}$'
set lime-node.pushgateway.user='${pushgateway_user}'
set lime-node.pushgateway.password='${pushgateway_password}'
commit lime-node
EOF

private_key=''
listen_port=''

server_public_key=''
endpoint_host=''
endpoint_port=''
allowed_ips='192.168.0.0/16'

ipv4_host=$(uci get network.lan.ipaddr | sed 's|.*\.\(.*\..*\)|\1|')
ipv4_address='192.168.${ipv4_host}/16'

# https://github.com/openwrt/openwrt/issues/13211#issuecomment-2504873753
uci -q batch << EOF
set network.wg1=interface
set network.wg1.proto='wireguard'
set network.globals.packet_steering='1'

add network wireguard_wg1
set network.@wireguard_wg1[0].description='Remote debug wg1'
set network.@wireguard_wg1[0].public_key='${server_public_key}'
add_list network.@wireguard_wg1[0].allowed_ips='${allowed_ips}'
set network.@wireguard_wg1[0].persistent_keepalive='25'
set network.@wireguard_wg1[0].endpoint_host='${endpoint_host}'
set network.@wireguard_wg1[0].endpoint_port='${endpoint_port}'

set network.wg1.private_key='${private_key}'
set network.wg1.listen_port='${listen_port}'
add_list network.wg1.addresses='${ipv4_address}'
set network.wg1.nohostroute='1'

add network route
set network.@route[-1].interface='wg1'
set network.@route[-1].target='${allowed_ips}'
commit network
EOF

lime-config; lime-apply;
exit 0
```