#!/bin/sh
# checks for deaf interfaces and brings them up, only if there are associated stations

for num in 0 1; do
    if [ -d /sys/kernel/debug/ieee80211/phy$num/netdev\:wlan$num-adhoc ]; then
        logger "deaf_phys: checking wlan$num-adhoc status..."
        neighs=$(ls -ld /sys/kernel/debug/ieee80211/phy$num/netdev\:wlan$num-adhoc/stations/* 2>/dev/null | wc -l)
        if [ $neighs == 0 ]; then
            logger "deaf_phys: triggering wlan$num-adhoc scan..."
            iw wlan$num-adhoc scan
        else
            logger "deaf_phys: wlan$num-adhoc has $neighs neighbors."
        fi
    fi
done

