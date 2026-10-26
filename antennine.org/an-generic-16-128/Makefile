include $(TOPDIR)/rules.mk

PROFILE_DESCRIPTION:=Generic metapackage for devices with at least 16MB flash and 128MB RAM \
	with lime files, pubkeys and metrics, and eff ca-cert
PROFILE_DEPENDS:=\
	+lime-owut \
	+profile-antennine.org-an-ca-bundle \
	+profile-antennine.org-an-generic \
	+profile-antennine.org-an-metrics \
	+profile-antennine.org-an-16-128

include ../../profile.mk

# call BuildPackage - OpenWrt buildroot signature
