#!/bin/bash

# This file is a cooking script for openNET.io
# Execute from one level above [just outside] lime-sdk extracted folder
# All routers we use should be in this file for one touch cooking
#
# Started on 20170519 | Nk
# Last updated on 20170722 | Nk
#
# Packages still to test: haveged

# Uncomment to install packages on ubuntu

# sudo apt-get update
# sudo apt-get -y install gawk zlib1g-dev libncurses5-dev g++ flex git

echo
echo "starting cook"
echo

dir=lime-sdk
git clone https://github.com/libremesh/lime-sdk.git temp
rsync -a temp/ $dir/
rm -rf temp
mv $dir/communities $dir/communities-previousrun
mv $dir/output $dir/output-previousrun

cd $dir

# Archer C7 v2 [standard and openNODE]

PKG="lime-full luci-ssl wpad authsae hostapd ath10k-firmware-qca988x kmod-ath10k nano -wpad-mini" \
./cooker --flavor=lime_default --remote \
--community=openNET.io/1144-W2PA-LIME-XXXX -c ar71xx/generic --profile=archer-c7-v2

PKG="lime-full luci-ssl wpad authsae hostapd ath10k-firmware-qca988x kmod-ath10k nano -wpad-mini" \
./cooker --flavor=lime_default --remote \
--community=openNET.io/1144-W2PA-LIME-XXXX_ONC7 -c ar71xx/generic --profile=archer-c7-v2

# 1043 ND v3 [standard and openNODE]

PKG="lime-full luci-ssl wpad authsae hostapd ath10k-firmware-qca988x kmod-ath10k nano -wpad-mini" \
./cooker --flavor=lime_default --remote \
--community=openNET.io/1144-W2PA-LIME-XXXX -c ar71xx/generic --profile=tl-wr1043nd-v3

PKG="lime-full luci-ssl wpad authsae hostapd ath10k-firmware-qca988x kmod-ath10k nano -wpad-mini" \
./cooker --flavor=lime_default --remote \
--community=openNET.io/1144-W2PA-LIME-XXXX_ON3N -c ar71xx/generic --profile=tl-wr1043nd-v3

PKG="lime-full luci-ssl wpad authsae hostapd ath10k-firmware-qca988x kmod-ath10k nano -wpad-mini" \
./cooker --flavor=lime_default --remote \
--community=openNET.io/1144-W2PA-LIME-XXXX_ON32 -c ar71xx/generic --profile=tl-wr1043nd-v3

# 1043 ND v4 [standard and openNODE]

PKG="lime-full luci-ssl wpad authsae hostapd ath10k-firmware-qca988x kmod-ath10k nano -wpad-mini" \
./cooker --flavor=lime_default --remote \
--community=openNET.io/1144-W2PA-LIME-XXXX -c ar71xx/generic --profile=tl-wr1043nd-v4

PKG="lime-full luci-ssl wpad authsae hostapd ath10k-firmware-qca988x kmod-ath10k nano -wpad-mini" \
./cooker --flavor=lime_default --remote \
--community=openNET.io/1144-W2PA-LIME-XXXX_ON3N -c ar71xx/generic --profile=tl-wr1043nd-v4

PKG="lime-full luci-ssl wpad authsae hostapd ath10k-firmware-qca988x kmod-ath10k nano -wpad-mini" \
./cooker --flavor=lime_default --remote \
--community=openNET.io/1144-W2PA-LIME-XXXX_ON32 -c ar71xx/generic --profile=tl-wr1043nd-v4

# 841 v11 [4MB!]

PKG="wpad -wpad-mini" \
./cooker --flavor=lime_zero --remote \
--community=openNET.io/1144-W2PA-LIME-XXXX -c ar71xx/generic --profile=tl-wr841-v11

# WBS 210

PKG="lime-full luci-ssl wpad authsae hostapd ath10k-firmware-qca988x kmod-ath10k nano -wpad-mini" \
./cooker --flavor=lime_default --remote \
--community=openNET.io/1144-W2PA-LIME-XXXX -c ar71xx/generic --profile=wbs210

# Unifi AC Lite

PKG="lime-full luci-ssl wpad authsae hostapd ath10k-firmware-qca988x kmod-ath10k nano -wpad-mini" \
./cooker --flavor=lime_default --remote \
--community=openNET.io/1144-W2PA-LIME-XXXX -c ar71xx/generic --profile=ubnt-unifiac-lite

# Unifi AC Pro

PKG="lime-full luci-ssl wpad authsae hostapd ath10k-firmware-qca988x kmod-ath10k nano -wpad-mini" \
./cooker --flavor=lime_default --remote \
--community=openNET.io/1144-W2PA-LIME-XXXX -c ar71xx/generic --profile=ubnt-unifiac-pro

# AR 150

PKG="lime-full luci-ssl wpad authsae hostapd ath10k-firmware-qca988x kmod-ath10k nano -wpad-mini" \
./cooker --flavor=lime_default --remote \
--community=openNET.io/1144-W2PA-LIME-XXXX -c ar71xx/generic --profile=gl-ar150

# AR 300

PKG="lime-full luci-ssl wpad authsae hostapd ath10k-firmware-qca988x kmod-ath10k nano -wpad-mini" \
./cooker --flavor=lime_default --remote \
--community=openNET.io/1144-W2PA-LIME-XXXX -c ar71xx/generic --profile=gl-ar300

# AR 300M

PKG="lime-full luci-ssl wpad authsae hostapd ath10k-firmware-qca988x kmod-ath10k nano -wpad-mini" \
./cooker --flavor=lime_default --remote \
--community=openNET.io/1144-W2PA-LIME-XXXX -c ar71xx/generic --profile=gl-ar300m

# 3020 8M

PKG="lime-full luci-ssl wpad authsae hostapd ath10k-firmware-qca988x kmod-ath10k nano -wpad-mini" \
./cooker --flavor=lime_default --remote \
--community=openNET.io/1144-W2PA-LIME-XXXX -c ramips/mt7620 --profile=wt3020-8M

# UBNT Bullet / Pico M2

PKG="lime-full luci-ssl wpad authsae hostapd ath10k-firmware-qca988x kmod-ath10k nano -wpad-mini" \
./cooker --flavor=lime_default --remote \
--community=openNET.io/1144-W2PA-LIME-XXXX -c ar71xx/generic --profile=ubnt-bullet-m

# UBNT Rocket M2

PKG="lime-full luci-ssl wpad authsae hostapd ath10k-firmware-qca988x kmod-ath10k nano -wpad-mini" \
./cooker --flavor=lime_default --remote \
--community=openNET.io/1144-W2PA-LIME-XXXX -c ar71xx/generic --profile=ubnt-rocket-m

echo "cook finished"
echo

