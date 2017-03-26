#!/bin/sh
### Workaround dnsmasq procd init.d bug
sed -i 's,procd_add_raw_trigger "interface.*" 2000,procd_add_raw_trigger "interface.*" 60000,' /etc/init.d/dnsmasq
