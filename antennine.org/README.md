# antennine.org

Profiles in use in the network Antennine, Italy https://antennine.org

Below an example uci-defaults script used with ASU (online imagebuilder) to configure:
- prometheus-node-exporter via the package `profile-antennine.org-an-metrics`
- wireguard via `profile-antennine.org-an-wireguard`

/etc/uci-defaults/99-asu-defaults
```
pushgateway_token=''
wireguard_wg1_private_key=''
# wg1_addresses=''
# hostname='ninux-%M4%M5%M6'
# domain='antennine.org'
wireguard_wg1_addresses="$(uci get network.lan.ipaddr | sed 's|^[[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}|192.168|')"
wireguard_wg1_addresses=${wg1_addresses:-$wireguard_wg1_addresses}

uci -q batch <<EOF
set lime-node.system=lime
# set lime-node.system.hostname='${hostname}'
# set lime-node.system.domain='${domain}'
set lime-node.wg1=wireguard
set lime-node.wg1.private_key='${wireguard_wg1_private_key}'
set lime-node.wg1.listen_port='51800'
set lime-node.wg1.addresses='${wireguard_wg1_addresses}$'
set lime-node.prometheus=generic_uci_config
set lime-node.prometheus.uci_set='prometheus-node-exporter-ucode.pushgateway0=pushgateway'
add_list lime-node.prometheus.uci_set='prometheus-node-exporter-ucode.pushgateway0.host=panorama.antennine.org/pushgateway'
add_list lime-node.prometheus.uci_set='prometheus-node-exporter-ucode.pushgateway0.token=${pushgateway_token}'
commit lime-node
EOF

exit 1
commit lime-node
EOF
```

lime-config

exit 1
