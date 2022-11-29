include $(TOPDIR)/rules.mk

PROFILE_NAME=$(notdir ${CURDIR})
PROFILE_COMMUNITY=$(lastword $(filter-out $(PROFILE_NAME),$(subst /, ,$(CURDIR))))

PKG_NAME:=profile-$(PROFILE_COMMUNITY)-$(PROFILE_NAME)
PKG_MAINTAINER?=$(PROFILE_MAINTAINER)

# from https://github.com/openwrt/luci/blob/master/luci.mk
PKG_VERSION?=$(if $(DUMP),x,$(strip $(shell \
	if svn info >/dev/null 2>/dev/null; then \
		revision="svn-r$$(LC_ALL=C svn info | sed -ne 's/^Revision: //p')"; \
	elif git log -1 >/dev/null 2>/dev/null; then \
		revision="svn-r$$(LC_ALL=C git log -1 | sed -ne 's/.*git-svn-id: .*@\([0-9]\+\) .*/\1/p')"; \
		if [ "$$revision" = "svn-r" ]; then \
			set -- $$(git log -1 --format="%ct %h" --abbrev=7); \
			secs="$$(($$1 % 86400))"; \
			yday="$$(date --utc --date="@$$1" "+%y.%j")"; \
			revision="$$(printf 'git-%s.%05d-%s' "$$yday" "$$secs" "$$2")"; \
		fi; \
	else \
		revision="unknown"; \
	fi; \
	echo "$$revision" \
)))
PKG_RELEASE?=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=lime
  SUBMENU:=network-profile
  CATEGORY:=LibreMesh
  TITLE:=$(if $(PROFILE_TITLE),$(PROFILE_TITLE),Profile $(PROFILE_COMMUNITY) $(PROFILE_NAME))
  DEPENDS:=+lime-system $(PROFILE_DEPENDS)
  VERSION:=$(if $(PKG_VERSION),$(PKG_VERSION),$(PKG_SRC_VERSION))
  PKGARCH:=all
  URL:=https://github.com/libremesh/network-profiles/
endef

ifneq ($(PROFILE_DESCRIPTION),)
 define Package/$(PKG_NAME)/description
   $(strip $(PROFILE_DESCRIPTION))
 endef
endif

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/
	# check if root/ directory exists before copying
	if [ -e ./root/* ]; then $(CP) -r ./root/* $(1)/; fi
endef

define Build/Compile

endef

define Build/Configure
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
