# Hardware

## Outdoor

[Plasma Cloud PA1200](https://openwrt.org/toh/hwdata/plasma_cloud/plasma_cloud_pa1200)

## Indoor

[Xiaomi Mi Router 4A Gigabit Edition](https://openwrt.org/inbox/toh/xiaomi/xiaomi_mi_router_4a_gigabit_edition)

Beware when you buy this router: the old edition is possible to flash, but if you update the vendor firmware or you buy the new edition, it is not possible to flash anymore!

# Profiles

## Gateway

Has the PoE port configured as a WAN, to be connected to the fiber modem.

Wifi ports:

* 2.4 GHz: channel 6, used for AP and mesh
* 5 GHz: channel 64, used only for mesh

## Outdoor

Identical to the gateway profile, but the WAN is not configured as a WAN (it is used as a LAN). This is so because we want to use that port for connecting to other LibreMesh nodes, instead of having to run a second cable from the outdoor router to the indoor one.

## Indoor

The same as the gateway profile (in this case, to have a port configured as WAN can be useful in case there is some problem with the internet access and someone decides to plug in a cellular data gateway).

Wifi ports:

* 2.4 GHz: channel 1, used for AP and mesh
* 5 GHz: channel 40, used for AP and mesh

## -crypt vs -open

The *-crypt* version includes wpad-openssl, which allows us to encrypt the mesh connections with a password shared by all the nodes. Also, it would allow us to use Opportunistic Wireless Encryption (OWE), but this is not yet easy using LibreMesh. The only advantage to use the *-open* version, is that it fits in devices with smaller flash memory.

# Compiling

Follow the instructions on https://libremesh.org/development.html for installing the compilation dependencies and downloading the sources of OpenWrt. Make sure you take a modern version of OpenWrt: at least the 22.03 version.

Stop before launching `make menuconfig` and use the `DOTconfig` files you find in this repository instead.
