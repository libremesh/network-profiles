#!/bin/sh

uci set network.guifiroute=route
uci set network.guifiroute.interface=lan
uci set network.guifiroute.target=10.0.0.0
uci set network.guifiroute.netmask=255.0.0.0
uci set network.guifiroute.gateway=10.1.105.11
uci commit network
