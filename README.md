# network-profiles
Set of profiles for the networks using LibreMesh used by the firmware cooker [lime-sdk](https://github.com/libremesh/lime-sdk).

* Each community profile goes into a directory named as the community.
* Inside a community profile directory goes the devices profile, also split in directories
* The files available into community/device will be copied to the output firmware binary

The expected files to be into this repository are:

* Customized /etc/config/lime-defaults
* Set of scripts to configure/fix/add small specific stuff on the system (/etc/uci-defaults)
* SSH public keys from the community administrators (/etc/dropbear/authorized_keys)
* Any other stuff you need to customize your own community network firmware

There will be a branch per LibreMesh release so the set of files might be different according to the release.
