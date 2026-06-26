#!/bin/sh

[[ "$(pidof align.sh)" =~ [[:space:]]+ ]] && 
	echo 'already running' && return

ln -s /tmp/align_result.txt /www/align_result.txt 2>/dev/null

mode="mesh"
if [[ "$1" =~ "^(ap|apname|mesh)$" ]]; then
mode=$1
fi

# active ifaces
ifaces=""
for i in 0 1 2; do
	if [ "$(ip link show wlan${i}-${mode})" ]; then
		ifaces="${ifaces} ${i}"
	fi
done

# terminate after 1 hour
end=$((EPOCHSECONDS + 3600))

while [ "$EPOCHSECONDS" -le "$end" ]; do
	echo -e $(date +"%Y/%m/%d %H:%M:%S") "\n" > /tmp/align_result.txt

	for i in $ifaces; do
		echo "Interface: wlan${i}-${mode}:" >> /tmp/align_result.txt
		iwinfo wlan${i}-${mode} assoclist >> /tmp/align_result.txt
	done

	sleep 2
done &
