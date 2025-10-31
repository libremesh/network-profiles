include $(TOPDIR)/rules.mk

PROFILE_DESCRIPTION:=Generic metapackage for 8MB flash and/or 64MB RAM devices \
	with lime files, pubkeys and metrics, and eff ca-cert
PROFILE_DEPENDS:=\
	+profile-antennine.org-ca-bundle \
	+profile-antennine.org-generic \
	+profile-antennine.org-metrics \
	+profile-antennine.org-outdoor-8-64 

include ../../profile.mk

# call BuildPackage - OpenWrt buildroot signature
