include $(TOPDIR)/rules.mk

PROFILE_DESCRIPTION:=Compatibility with Temba firmware with BMX6
PROFILE_DEPENDS:=+lime-proto-bmx6 \
	+lime-proto-anygw \
	+lime-debug \
	+bmx6 +bmx6-json +bmx6-sms +bmx6-uci-config +bmx6-table +luci +luci-app-bmx6 +luci-compat +tcpdump-mini +iperf3 +netperf +ip +netcat +mtr +xl2tpd +wireguard +luci-app-wireguard

include ../../profile.mk

# call BuildPackage - OpenWrt buildroot signature
