OW_BRANCH:=$(shell echo $$(grep -m1 -o "releases/.*" $(TOPDIR)/include/version.mk 	
	|| echo "main") | cut -d"/" -f2 | cut -d"-" -f1 | cut -d"." -f1,2)
ifneq ($(OW_BRANCH),main)
	ifeq ($(shell test $$(echo "$(OW_BRANCH)" | cut -d"." -f1) -lt 25; echo $$?),0)
include ../../_hacks/opkg.mk
	else
include ../../_hacks/apk.mk
	endif
else
include ../../_hacks/apk.mk
endif
