# profile-antennine.org-metrics

Example of required configuration when building via asu.
Replace pushgateway host, <httpd_user> and <httpd_password>.

/etc/uci-defaults/99-asu-defaults
```
uci -q batch <<EOF
set lime-node.pushgateway=lime
set lime-node.pushgateway.host='panorama.antennine.org/pushgateway'
set lime-node.pushgateway.user='<httpd_user>'
set lime-node.pushgateway.password='<httpd_password>'
commit lime-node
EOF

lime-config
```
