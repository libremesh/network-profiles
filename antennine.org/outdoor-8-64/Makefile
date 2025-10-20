include $(TOPDIR)/rules.mk

PROFILE_DESCRIPTION:=Generic metapackage for 8MB flash and/or 64MB RAM devices
PKG_NAME:=profile-antennine.org-outdoor-8-64
PKG_CONFLICTS:=\
	-dnsmasq \
	-odhcpd-ipv6only \
	-opkg \
	-ppp \
	-ppp-mod-pppoe
PROFILE_DEPENDS:=\
	+batctl-default \
	+babeld-auto-gw-mode \
	+check-date-http \
  +lime-debug \
	+lime-docs-minimal \
	+lime-hwd-openwrt-wan \
	+lime-proto-anygw \
	+lime-proto-babeld \
	+lime-proto-batadv \
	+owut \
	+shared-state \
	+shared-state-babeld_hosts \
	+shared-state-nodes_and_links

# hack to deselect openwrt's default_packages. To be used by at most by one metapackage/network-profile
# warn: here TOPDIR is calculated by SDK, so it works with dockerized SDK and IB that use the same /builder
define Package/$(PKG_NAME)/preinst
#!/bin/sh
[ -z "$${IPKG_INSTROOT}" ] && exit 0
echo "########################################################################## Inside package preinst"
grep -q IB_MODIFIED_BY_$(PKG_NAME) $(TOPDIR)/Makefile && exit 0
echo "########################################################################## Determine make's target"
R=$$(for cmd in $$(ls -l /proc/*/exe | grep make | sed 's|.*/proc/\(.*\)/exe.*|\1|' | tr '\n' ' ' | tr -d '\0' ) ; do cat "/proc/$${cmd}/cmdline"; done)
make_target=$$(echo "$${R}" | grep -q manifest && echo 'manifest' || echo 'image')
echo "make_target: $${make_target}"
echo "########################################################################## Backup original Makefile"
cp $(TOPDIR)/Makefile $(TOPDIR)/Makefile.orig
echo "########################################################################## Terminate the execution after the second make image/manifest"
cat << EOF > /tmp/hack_pkg_conflicts
	cp $(TOPDIR)/Makefile.orig $(TOPDIR)/Makefile
	kill $$(ls -l /proc/*/exe | grep make | sed 's|.*/proc/\(.*\)/exe.*|\1|' | tr '\n' ' ' )
EOF
[ "$${make_target}" = "image" ] \
	&& sed -i '/^manifest:\ /e cat /tmp/hack_pkg_conflicts' $(TOPDIR)/Makefile \
	|| sed -i '/^package_whatdepends:\ /e cat /tmp/hack_pkg_conflicts' $(TOPDIR)/Makefile
echo "########################################################################## Add PKG_CONFLICTS to be removed in the main Makefile"
sed -i 's|\($$(USER_PACKAGES)\) \($$(BUILD_PACKAGES)\)|\1 $(PKG_CONFLICTS) \2|' $(TOPDIR)/Makefile
echo "# IB_MODIFIED_BY_$(PKG_NAME)" >> $(TOPDIR)/Makefile
echo "########################################################################## Re-run make image with the untouched MAKEFLAGS"
make "$${make_target}"
endef

include ../../profile.mk

# call BuildPackage - OpenWrt buildroot signature
