include $(TOPDIR)/rules.mk

PROFILE_DESCRIPTION:=Generic metapackage for 8MB flash and/or 64MB RAM devices \
	with lime files, pubkeys and metrics, and eff ca-cert
PROFILE_DEPENDS:=\
	+profile-antennine.org-an-ca-bundle \
	+profile-antennine.org-an-generic \
	+profile-antennine.org-an-lime-owut \
	+profile-antennine.org-an-metrics \
	+profile-antennine.org-an-outdoor-8-64

include ../../profile.mk

# call BuildPackage - OpenWrt buildroot signature
