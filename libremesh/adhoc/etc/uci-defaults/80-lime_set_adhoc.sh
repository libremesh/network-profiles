#!/bin/sh

uci del_list lime-defaults.network.protocols=ieee80211s
uci show lime-defaults.network.protocols | \
  grep -q adhoc || uci add_list lime-defaults.network.protocols=adhoc

uci del_list lime-defaults.wifi.modes=ieee80211s
uci show lime-defaults.wifi.modes | \
  grep -q adhoc || uci add_list lime-defaults.wifi.modes=adhoc

uci commit lime-defaults

exit 0
