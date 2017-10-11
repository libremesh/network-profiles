#!/bin/sh
uci add_list lime-defaults.network.protocols=bmx6:13
uci del_list lime-defaults.network.protocols=batadv:%N
uci del_list lime-defaults.network.protocols=olsr:14
uci del_list lime-defaults.network.protocols=olsr6:15
uci del_list lime-defaults.network.protocols=olsr2:16
uci del_list lime-defaults.network.protocols=anygw
uci set lime-defaults.network.main_ipv4_address='10.0.0.0/27/8'
uci set lime-defaults.network.main_ipv6_address='2a00:1508:0a%M4:%M600::/64'
uci commit lime-defaults
exit 0
