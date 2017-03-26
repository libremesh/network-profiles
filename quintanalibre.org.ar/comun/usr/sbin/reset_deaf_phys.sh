#!/bin/sh
# checks for deaf interfaces and brings them up, only if there are associated stations

for num in 0 1; do
logger "deaf_phys: checking wlan$num-adhoc status..."

  if [ -f /sys/kernel/debug/ieee80211/phy$num/statistics/dot11RTSSuccessCount ]; then
#  && [ -n "$(ls -1d /sys/kernel/debug/ieee80211/phy$num/netdev*/stations/*)" ] ; then
    ### Won't enter here if there is no phy$num or it has no stations at all
    ### But double check: Only continue if there's any station active in the last second
#      egrep -q "^.{1,3}$"  /sys/kernel/debug/ieee80211/phy$num/netdev*/stations/*/inactive_ms 2>/dev/null || exit
    
    success_a=`cat /sys/kernel/debug/ieee80211/phy$num/statistics/dot11RTSSuccessCount`
    for fe80 in `bmx6 -c show links | grep fe80 |  grep wlan$num |  awk '{ print $2 }'`; do
        ping6 -c 30 -i 0.1 -q -w 5  $fe80%wlan$num-adhoc
    done
    success_b=`cat /sys/kernel/debug/ieee80211/phy$num/statistics/dot11RTSSuccessCount`

    num_all_neigh=$(ls -1d /sys/kernel/debug/ieee80211/phy$num/netdev*/stations/* | wc -l)
    diff_success=$(( $success_b - $success_a ))

    if [ $success_a == $success_b ]; then
      netdev=$(ls -1d /sys/kernel/debug/ieee80211/phy$num/netdev* | head -n1 | cut -d \: -f 2)
      logger "deaf_phys wlan$num-adhoc is trulala: has $num_all_neigh neighbors: 10sec diff RTSSuccess=$diff_success rebooting."
      reboot;
    else
        logger "deaf_phs wlan$num-adhoc is OK: has $num_all_neigh neighbors: 10sec diff RTSSuccess=$diff_success"
    fi
  fi
done
