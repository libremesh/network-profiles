# network-profiles
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
