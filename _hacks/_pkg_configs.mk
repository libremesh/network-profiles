# hack to define/modify configs among those evaluated by the imagebuilder
define Package/$(PKG_NAME)/preinst_pkg_configs
for config in "$(PKG_CONFIGS)"; do
	grep -q "$${config}" $${TOPDIR}/.config && continue
	need_rerun=1
	if [ "$${config:0:1}" = '#' ]; then
		sed -i "s|$${config:2:-11}}=y|$${config}|" $${TOPDIR}/.config
	else
		config_name="$$(echo $${config} | cut -d '=' -f 1)"
		sed -i "s|# $${config_name} is not set|$${config}|" $${TOPDIR}/.config
	fi
done
endef
