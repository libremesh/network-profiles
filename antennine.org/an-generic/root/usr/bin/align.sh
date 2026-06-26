#!/bin/sh

[[ "$(pidof align.sh)" =~ [[:space:]]+ ]] && 
	echo 'already running' && return

# cgi-script
if [ ! -f /www/cgi-bin/align ]; then
cat  << EOF > /www/cgi-bin/align
#!/bin/sh

echo "Status: 200"
echo "Content-type: text/plain;"
echo "Cache-control: max-age=0, no-cache;"
echo "Access-Control-Allow-Origin: *"
echo "Access-Control-Allow-Methods: GET;"
echo

running=\$(pidof align.sh)
if [ "\${running}" ]; then
	kill "\${running}"
	echo "align.sh stopped"
else
    mode="mesh"
    if [[ "\$QUERY_STRING" =~ "^(ap|apname|mesh)$" ]]; then
        mode="\$QUERY_STRING"
    else
	    return
    fi
    align.sh \$mode &
    echo "align.sh \$mode started"
fi
EOF
chmod +x /www/cgi-bin/align
fi

# html
if [ ! -f /www/align.html ]; then
cat  << EOF > /www/align.html
<html>
<head>
  <title>Alignment</title>
</head> 
<body>
<select id="mode">
    <option value="mesh">mesh</option>
    <option value="ap">ap</option>
    <option value="apname">apname</option>
</select>
<button id="toggle">Start/Stop</button>
<span id="status"></span>
<pre id="result"></pre>
<script>
document.getElementById('toggle').addEventListener('click', () => {
	let res = new XMLHttpRequest()
	res.onreadystatechange = function() {
		if (this.readyState == 4 && this.status == 200) {
			document.getElementById('status').innerText = this.responseText
		}
	};
    let mode = document.getElementById('mode').value
	res.open('GET', '/cgi-bin/align?'+mode)
	res.send()
})

setInterval(function () {
	let res = new XMLHttpRequest()
	res.onreadystatechange = function() {
		if (this.readyState == 4 && this.status == 200) {
			document.getElementById('result').innerText = this.responseText
		}
	};
	res.open('GET', '/align_result.txt')
	res.send()
}, 2000)
</script>
</body>
</html>
EOF
fi

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
	date +"%Y/%m/%d %H:%M:%S" > /tmp/align_result.txt
    echo "" >> /tmp/align_result.txt

	for i in $ifaces; do
		echo "Interface: wlan${i}-${mode}:" >> /tmp/align_result.txt
		iwinfo wlan${i}-${mode} assoclist >> /tmp/align_result.txt
	done

	sleep 2
done &
