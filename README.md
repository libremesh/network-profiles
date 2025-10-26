# network-profiles

**Check out the full documentation on https://libremesh.org/development-network_profiles.html**

Set of profiles for the networks using LibreMesh used by the [firmware builder](https://libremesh.org/development.html).

* Each community profile goes into a directory named as the community.
* Inside a community profile directory goes the devices profile, also split in directories
* The files available into `community/device/root/` will be copied to the output firmware binary

The expected files to be into this repository are:

* Customized `/etc/config/lime-community`
* Set of scripts to configure/fix/add small specific stuff on the system in `/etc/uci-defaults/`
* SSH public keys from the community administrators in `/etc/dropbear/authorized_keys`
* Any other stuff you need to customize your own community network firmware

A special file named `Makefile` have to be placed in the device directory `community/device/Makefile`, see [this file](https://github.com/libremesh/network-profiles/blob/master/libremesh/encrypt-11s/Makefile) as an example.
This file can also be used to include a list of extra packages which will be included in the firmware.

## Hacking

### hack_pkg_conflicts (imagebuilder)
Define a list of packages to be removed in PKG_CONFLICTS.    
Include then the `preinst` defined in `hack_pkg_conflicts.mk` to do the package removal, like in the example below:    
Warn: To use it with asu, the server must support this hack.    
Warn: To use it with the firmware-selector (by now) be sure to include the profile as first in the package's list.
```
include $(TOPDIR)/rules.mk

PROFILE_DESCRIPTION:=Generic libremesh metapackage
PKG_CONFLICTS:=\
	-dnsmasq \
	-odhcpd-ipv6only
PROFILE_DEPENDS:=\
	+profile-libremesh-suggested-packages

include ../../hack_pkg_conflicts.mk
include ../../profile.mk

# call BuildPackage - OpenWrt buildroot signature

```