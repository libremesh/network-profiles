#!/bin/sh

uci del_list lime-defaults.network.protocols=adhoc
uci show lime-defaults.network.protocols | \
  grep -q ieee80211s || uci add_list lime-defaults.network.protocols=ieee80211s
  
uci del_list lime-defaults.wifi.modes=adhoc
uci show lime-defaults.wifi.modes | \
  grep -q ieee80211s || uci add_list lime-defaults.wifi.modes=ieee80211s
    
uci commit lime-defaults
    
exit 0
