include $(TOPDIR)/rules.mk

PROFILE_NAME=$(notdir ${CURDIR})
PROFILE_COMMUNITY=$(lastword $(filter-out $(PROFILE_NAME),$(subst /, ,$(CURDIR))))

PKG_NAME:=profile-$(PROFILE_COMMUNITY)-$(PROFILE_NAME)
PKG_MAINTAINER?=$(PROFILE_MAINTAINER)

# from https://github.com/openwrt/luci/blob/master/luci.mk 
# default package version follow this scheme:
# [year].[day_of_year].[seconds_of_day]~[commit_short_hash] eg. 24.322.80622~a403707
PKG_VERSION?=$(if $(DUMP),x,$(strip $(shell \
    if git log -1 >/dev/null 2>/dev/null; then \
      set -- $$(git log -1 --format="%ct %h" --abbrev=7); \
        secs="$$(($$1 % 86400))"; \
        yday="$$(date --utc --date="@$$1" "+%y.%j")"; \
        printf '%s.%05d~%s' "$$yday" "$$secs" "$$2"; \
    else \
      echo "0"; \
    fi; \
)))

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=lime
  SUBMENU:=network-profile
  CATEGORY:=LibreMesh
  TITLE:=$(if $(PROFILE_TITLE),$(PROFILE_TITLE),Profile $(PROFILE_COMMUNITY) $(PROFILE_NAME))
  DEPENDS:=+lime-system $(PROFILE_DEPENDS)
  VERSION:=$(PKG_VERSION)
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
	if [ -e ./root/ ]; then $(CP) -r ./root/* $(1)/; fi
endef

define Build/Compile

endef

define Build/Configure
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
