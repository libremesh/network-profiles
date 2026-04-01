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

## Hacking (imagebuilder)
Add to your network profile a script that **contains build instructions**.    
And that triggers a nested build with adjusted options if some packages weren't removed or some configs were missing.   
This is done using a package `preinst` with opkg or a `postinst` with apk.

This hacks is meant to be sure to build saving firmware space and ram on **8/64 devices**:
- To prevent flashing a firmware that fit in the flash but cause the device to reboot for OOM
- To simplify the removal of openwrt's default packages allowing one to build libremesh specifing a single package,   
  i.e. `make image profile-antennine.org-an-8-64`

### Supported options:
- `PKG_CONFIGS`: Define a list of configs to be modified, i.e `CONFIG_CLEAN_IPKG` (opkg only).
- `PKG_CONFLICTS`: Define a list of packages to be removed, i.e. `-dnsmasq -odhcpd-ipv6only` (apk and opkg).

### Warnings:
- Usable safely with **ImageBuilder docker**, since it will try to kill every `pidof make`.
- To use it with **ASU** (online imagebuilder), the server must support this hack.    
	Currently the ASU server https://sysupgrade-01.antennine.org supports it:
	- Do not return errors if the main build was killed after the nested build completes
	- Prepend packages that starts with `profile-` at the beginning of the packages list    
  	to speed up the build making the nested build happens as first `preinst` (opkg only),    
		needed when using the **firmware-selector** that do request builds including all packages and using the ASU's `diff_packages` feature
	- Checking the manifest from a file printed in BIN_DIR/manifest instead from STDOUT (opkg only)

### Usage:   
Inside a network-profile add an include for `../../_hacks/index.mk` before the inclusion of `../../profile.mk`
```
include $(TOPDIR)/rules.mk

PROFILE_DESCRIPTION:=Generic libremesh metapackage
PKG_CONFIGS:=\
	CONFIG_CLEAN_IPKG=y
PKG_CONFLICTS:=\
	-dnsmasq \
	-odhcpd-ipv6only
PROFILE_DEPENDS:=\
	+profile-libremesh-suggested-packages

include ../../_hacks/index.mk
include ../../profile.mk

# call BuildPackage - OpenWrt buildroot signature

```
