# Environment and physical connections

Calafou has many areas to be covered, we focused on the zones needed by the Wireless Battlemesh v15.

Here you can see a map of the routers' positions (the underlying drawing can be found on https://agentliquide.com/):

![Calafou map of network](CALAFOU-B-network_map.jpg)

## Router A

Hardware: Plasma Cloud PA1200

Profile: outdoor_gateway

First ethernet: WAN connected to fiber modem (wan)

Second ethernet: unused, configured as LAN for cabled clients connections (lan1)

IP: 10.1.142.64

MAC: 4c:13:65:00:0e:40

## Router B

Hardware: Plasma Cloud PA1200

Profile: outdoor_nongateway

First ethernet: mesh, connected to PoE and to Router C (lan1, name to be confirmed)

Second ethernet: mesh, connected to Router D (lan2, name to be confirmed)

IP: 10.1.141.240

MAC: 4c:13:65:00:0d:f0

## Router C

Hardware: Xiaomi Mi Router 4A Gigabit Edition

Profile: indoor

First ethernet: unused, configured as WAN (wan)

Second ethernet: mesh, connected to Router B (lan1)

Third ethernet: unused, configured as LAN for cabled clients connections (lan2)

IP: 10.1.203.237

MAC: 64:64:4a:db:cb:ed

## Router D

Hardware: Xiaomi Mi Router 4A Gigabit Edition

Profile: indoor2

First ethernet: unused, configured as LAN (lan??), during Wireless BattleMesh v15 it has been used for connecting the OpenWisp-based testbed

Second ethernet: mesh, connected to Router B (lan1)

Third ethernet: mesh, connected to Router E (lan2)

IPv4: 10.1.206.105

MAC: 64:64:4a:db:ce:69

## Router E

Hardware: Xiaomi Mi Router 4A Gigabit Edition

Profile: indoor

First ethernet: unused, configured as WAN (wan)

Second ethernet: mesh, connected to Router D (lan1)

Third ethernet: unused, configured as LAN for cabled clients connections (lan2)

IP: 10.1.208.101

MAC: 64:64:4a:db:d0:65

# Hardware

## Outdoor

[Plasma Cloud PA1200](https://openwrt.org/toh/hwdata/plasma_cloud/plasma_cloud_pa1200)

## Indoor

[Xiaomi Mi Router 4A Gigabit Edition](https://openwrt.org/inbox/toh/xiaomi/xiaomi_mi_router_4a_gigabit_edition)

Beware when you buy this router: the old edition is possible to flash, but if you update the vendor firmware or you buy the new edition, it is not possible to flash anymore!

# Profiles

## Common to all profiles

A large selection of packages, including wpad-openssl, is used, resulting in large firmware images.

### lime-community configuration
```
config lime system
	option deferable_reboot_uptime_s '654321' # reboot every 7.5 days 
```

The deferable-reboot package is installed, and will reboot every node once per week. There should be no need for that, but just in case. If you don't want it to reboot you router, just set an exhaggeratedly large number here.

```
config lime network
	option main_ipv4_address '10.1.128.0/16/17'
```

The local network is 10.1.0.0/16 (which includes the IPs from 10.1.0.1 to 10.1.255.254), but the LibreMesh nodes will automatically take an IP in a smaller range (/17) of IPs: from 10.1.128.1 to 10.1.255.254.

```
	option anygw_dhcp_start '2562'
```

The IPs dynamically assigned by the DHCP of the nodes to the clients connecting will be in a range starting at 10.1.10.2 ( 10 * 256 + 2 = 2562 ).

```
	option anygw_dhcp_limit '30205'
```

Range that starts at 10.1.10.2, ends at 10.1.127.254 ( (127 - 10) * 256 + (254 - 2) + 1 = 30205 ).

So, the IPv4 network is divided in 3 spaces:
10.1.0.2--10.1.10.1 - available for static IPs, for example servers
10.1.10.2--10.1.127.254 - clients connecting to the network
10.1.128.1--10.1.255.254 - LibreMesh nodes

```
config lime wifi		
	option country 'ES'	
```

For respecting Spanish regulation in terms of usable wifi channels and output powers.

```
	option ap_ssid 'Calafou-to-be-configured'
	option apname_ssid 'Calafou/%H-to-be-configured'
```

Temporary ESSID, read below on "Post flashing".

Setting a new `ap_ssid` in `/etc/config/lime-node` (see below "Post flashing") also changes the VLAN used for Batman-adv layer2 routing protocol, but this should not be a problem.

```
	option ieee80211s_mesh_id 'libremesh'
```

The name of the mesh interface. Two routers will not mesh if this name is different.

### Packages

Packages suggested on the [LibreMesh website](https://libremesh.org/development.html) (except the WAN-related ones):

* lime-docs
* lime-proto-babeld
* lime-proto-batadv
* lime-proto-anygw
* shared-state
* hotplug-initd-services
* shared-state-babeld_hosts
* shared-state-bat_hosts
* shared-state-dnsmasq_hosts
* shared-state-dnsmasq_leases
* shared-state-nodes_and_links
* check-date-http
* lime-app
* lime-hwd-ground-routing
* lime-debug

Additional (maybe) useful packages:

* deferable-reboot 
* safe-reboot
* wpad-openssl
* shared-state-network_nodes
* shared-state-dnsmasq_servers
* prometheus-node-exporter-lua
* prometheus-node-exporter-lua-openwrt
* prometheus-node-exporter-lua-wifi_stations
* prometheus-node-exporter-lua-wifi-stations-extra
* prometheus-node-exporter-lua-wifi-survey
* prometheus-node-exporter-lua-wifi-params
* prometheus-node-exporter-lua-location-latlon
* iperf3

## outdoor_gateway

Has the PoE port configured as a WAN, to be connected to the fiber modem.

Wifi ports:

* 2.4 GHz: channel 1 (HT40, this will result in a wide channel centered around channel 3), used for AP and mesh
* 5 GHz: channel 36 (VHT80), used only for mesh

### lime-community configuration

As the "Common to all profiles" one but also with:

```
config lime-wifi-band '2ghz' 
	option channel '1'
    option htmode 'HT40'
	list modes 'ap'	
	list modes 'apname'
	list modes 'ieee80211s'
	option distance '300'

config lime-wifi-band '5ghz'
	option channel '36'
    option htmode 'VHT80'
	list modes 'ieee80211s'
	option distance '300'
```

### Packages

As the "Common to all profiles" list but also with:

* lime-hwd-openwrt-wan (which pulls also lime-proto-wan as a dependency)
* babeld-auto-gw-mode

## outdoor_nongateway

Identical to the outdoor_gateway profile, but the WAN is not configured as a WAN (it is used as a LAN). This is so because we want to use that port for connecting to other LibreMesh nodes, instead of having to run a second cable from the outdoor router to the indoor one.

### lime-community configuration

Identical to the outdoor_gateway profile, but both ethernet interfaces are specifically configured for not being included in the br-lan bridge, as when an ethernet port is used for meshing with Batman-adv seems that would cause loops.

### Packages

Identical to the list in "Common to all profiles" (so it does have the WAN port configured as a normal LAN port, missing the lime-hwd-openwrt-wan package).

## Indoor

The same as the outdoor_gateway profile (in this case, to have a port configured as WAN can be useful in case there is some problem with the internet access and someone decides to plug in a cellular data gateway).

Wifi ports:

* 2.4 GHz: channel 13 (HT20), used for AP
* 5 GHz: channel 100 (VHT80), used for AP

### lime-community configuration

As the "Common to all profiles", but the first ethernet interface labelled as LAN or internally as "lan1" is specifically configured for not being included in the br-lan bridge, as when an ethernet port is used for meshing with Batman-adv seems that would cause loops (the WAN is left as WAN and the second LAN is left as LAN).

And also with:

```
config lime-wifi-band '2ghz' 
	option channel '13'
    option htmode 'HT20'
	list modes 'ap'	
	list modes 'apname'
	option distance '100'

config lime-wifi-band '5ghz'
	option channel '100'
    option htmode 'VHT80'
	list modes 'ap'	
	list modes 'apname'
	option distance '100'

config net lan1onlymesh
	option linux_name 'lan1'
	#list protocols lan # we want all the protocols but LAN, as this ethernet port will be used for meshing, not for clients access
	list protocols anygw
	list protocols batadv:%N1
	list protocols babeld:17

config generic_uci_config 
	list uci_set 'wireless.radio0.beacon_int=50'
	list uci_set 'wireless.radio1.beacon_int=50'
```

The `lan1onlymesh` configuration is needed for avoiding loops (somehow, everything works anyway, but better to avoid the possibility of having loops), as when an interface is used for meshing with BATMAN-adv is better that that interface is not included in the `br-lan` LAN ports bridge. This means that a client connecting directly to that port will not receive an IP, and this port should be used only for connecting to other LibreMesh nodes.

The `beacon_int` parameter has been edited according to the observation by Pedro with the Xiaomi Mi Router 4A Gigabit Edition reported here: https://forum.openwrt.org/t/proposal-to-change-the-default-wifi-beacon-interval-from-100-ms-to-50-ms/158508

### Packages

Identical to the list for the outdoor_gateway profile.

## Indoor2

This is for rooms in which two router are placed, for not having both routers on the same channel.

The channel for 5 GHz is not overlapping with "indoor" or outdoor_nongateway and outdoor_gateway profiles.

Channel 10 for 2.4 GHz is going to collide a bit with the wide (HT40) channel used in the outdoor profiles and with the narrow (HT20) one used in the indoor profile. We will see if this is a problem.

Except for the channels, this is the same as the first "indoor" profile.

The channels used in this profile, will be the same employed for the OpenWISP-powered testbed that will be used during the BattleMesh v15 event.

Wifi channels:

* 2.4 GHz: channel 10 (HT20), used for AP
* 5 GHz: channel 52 (VHT80), used for AP

### lime-community configuration

As the "Common to all profiles", but both ethernet interfaces labelled as LAN are specifically configured for not being included in the br-lan bridge, as when an ethernet port is used for meshing with Batman-adv seems that would cause loops (the WAN is left as WAN).

And also with:

```
config lime-wifi-band '2ghz' 
	option channel '10'
	list modes 'ap'	
	list modes 'apname'
	option distance '100'

config lime-wifi-band '5ghz'
	option channel '52'
    option htmode 'VHT80'
	list modes 'ap'	
	list modes 'apname'
	option distance '100'

config net lan1onlymesh
	option linux_name 'lan1'
	#list protocols lan # we want all the protocols but LAN, as this ethernet port will be used for meshing, not for clients access
	list protocols anygw
	list protocols batadv:%N1
	list protocols babeld:17

config net lan2onlymesh
	option linux_name 'lan2'
	#list protocols lan # we want all the protocols but LAN, as this ethernet port will be used for meshing, not for clients access
	list protocols anygw
	list protocols batadv:%N1
	list protocols babeld:17

config generic_uci_config 
	list uci_set 'wireless.radio0.beacon_int=50'
	list uci_set 'wireless.radio1.beacon_int=50'
```

The `lan1onlymesh` configuration is needed for avoiding loops (somehow, everything works anyway, but better to avoid the possibility of having loops), as when an interface is used for meshing with BATMAN-adv is better that that interface is not included in the `br-lan` LAN ports bridge. This means that a client connecting directly to that port will not receive an IP, and this port should be used only for connecting to other LibreMesh nodes.

The `beacon_int` parameter has been edited according to the observation by Pedro with the Xiaomi Mi Router 4A Gigabit Edition reported here: https://forum.openwrt.org/t/proposal-to-change-the-default-wifi-beacon-interval-from-100-ms-to-50-ms/158508

### Packages

Identical to the list for the outdoor_gateway profile.

## Future profiles

These profiles includes many many packages, which makes the resulting firmware image to not fit in routers with only 8 MB of flash memory. For example, one heavy package is wpad-openssl, which allows us to encrypt the mesh connections with a password shared by all the nodes. Also, it would allow us to use Opportunistic Wireless Encryption (OWE), but this is not yet easy using LibreMesh.

So a possible future profile is a lightweight one for fitting in routers with smaller flash memory.

# Compiling

Follow the instructions on https://libremesh.org/development.html for installing the compilation dependencies and downloading the sources of OpenWrt. Make sure you take a modern version of OpenWrt: at least the 22.03 version.

In the `feeds.conf` file, **do not specify any branch or tag** for the `libremesh` (`lime-packages`) feed, so that the latest code is used.

Stop following the guide **before** launching `make menuconfig`.

Instead, copy one of the `DOTconfig-blahblah` files you find in this repository as `.config` file. This file already contains the minimum (maybe not strictly minimum...) configuration for getting the desired firmware for a specific router model. For getting the minimum configuration for compiling the "indoor" profile for a Xiaomi MiRouter 4A gigabit edition router, you can copy the compilation configuration file like this:

```
cp network-profiles/calafou/indoor/DOTconfig-xiaomi_mirouter_4A_gigabit_edition openwrt/.config
```

If you don't want to use the provided `.config` file, you can manually run `make menuconfig` and select the needed options setting them as `<*>` (e.g. the target, subtarget, model of router, network-profile in the LibreMesh menu...) one by one. Clearly, save when exiting.

After copying the `.config`, run `make defconfig`.

The `make defconfig` will complete your `.config` file with all the other default options.

If you then want to select something more (e.g. adding the `tc` package), simply run `make menuconfig` and add the desired software setting it as `<*>`. Save when exiting.

When you are happy with the selected software, run `make` or `make -j $(nproc)` for a bit faster compilation. The first compilation will take a 1-4 hours, requires internet connection, and needs up to 10 GB. The following times you compile the same target, will take less time.

# Connecting to the web interface of a router

Just connect to the wifi Access Point (AP) of a router and open http://thisnode.info

If it does not work, check if you are using the network's DNS server or a custom one: thisnode.info is managed by the nodes themselves, so you need to use them as DNS resolver.

In both cases, the closest router will answer.

If you want to make sure you are connecting to a specific router, connect to the AP with the MAC address in it, for example `Calafou/LiMe-000e40` and open the addresses above.

# Connecting via SSH the router

As for connecting to the web interface, you can use the thisnode.info:

```
ssh root@thisnode.info
```

Again, the closest node will answer. If you want to connect to a specific node, connect to its specific AP interface which looks similar to `Calafou/LiMe-000e40`.

Check out https://libremesh.org/docs/en_connecting_nodes.html

# Flashing

Follow the instructions on the OpenWrt wiki, specific for each router.

Typically, the process is like this:

```
PC$ cd openwrt/bin/TARGET/SUBTARGET
PC$ scp -O openwrt-BLABLA-sysupgrade.bin root@thisnode.info:/tmp
PC$ ssh root@thisnode.info
router# sysupgrade -n /tmp/openwrt-BLABLA-sysupgrade.bin
```


# Post flashing

The routers have by default a "Calafou-to-be-configured" ESSID. This is needed for remembering you to connect, set a root password, add you ssh keys, set any other fancy encryption you want and finally set the ESSID to the correct value.

That temporary ESSID will also appear if the router reset, for any reason. In this case, you also have to connect and set the aforementioned things.

In order:

* set the root password using `passwd`
* create a `/etc/dropbear/authorized_keys` with the public SSH key of the people that should be allowed to access the router
* add these lines at the bottom of `/etc/config/lime-node`:
```
    option ap_ssid 'Calafou'
	option apname_ssid 'Calafou/%H'
```
* apply the new ESSID with the `lime-config` command
* reboot with the `reboot` command

## Optional post-configuration stuff

Add in `/etc/config/lime-node` any encryption you need, see [/docs/lime-example.txt](https://github.com/libremesh/lime-packages/blob/master/packages/lime-docs/files/www/docs/lime-example.txt) about how to set a password for the AP and APname, and how to set a password for the mesh connections.

If you want to connect via SSH from the internet, forward the port on your modem and allow the SSH connections from the WAN port adding these lines in the `/etc/config/firewall`:

```
config rule
	option name 'Allow-SSH'
	option src 'wan'
	option proto 'tcp'
	option dest_port '22'
	option target 'ACCEPT'
```

In this case, you could disallow the password authentication (setting to `off` the `PasswordAuth` option in `/etc/config/dropbear` and rebooting), for making sure that nobody on the internet tries to bruteforce the root password. In this case, if you lose the private SSH key you will have to reset the router, that usually requires pressing a physical button on it.

# Troubleshooting

Check out this page: https://libremesh.org/docs/en_troubleshooting.html

Contact the LibreMesh or Battlemesh people.
