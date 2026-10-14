# antennine.org

Profiles in use in the network Antennine, Italy https://antennine.org

Below an example uci-defaults script used with ASU (online imagebuilder) to configure:
- prometheus-node-exporter via the package `profile-antennine.org-an-metrics`
- wireguard via `profile-antennine.org-an-wireguard`

/etc/uci-defaults/99-asu-defaults
```
# hostname='ninux-%M4%M5%M6'
# domain='antennine.org'
pushgateway_token=''
wireguard_wg1_private_key=''

uci -q batch <<EOF
set lime-node.system=lime
# set lime-node.system.hostname='${hostname}'
# set lime-node.system.domain='${domain}'
set lime-node.pushgateway=lime
set lime-node.pushgateway.token='${pushgateway_token}'
set lime-node.@wireguard_wg1[0]=wireguard_wg1
set lime-node.@wireguard_wg1[0].private_key='${wireguard_wg1_private_key}'
commit lime-node
EOF
```

lime-config

exit 0
