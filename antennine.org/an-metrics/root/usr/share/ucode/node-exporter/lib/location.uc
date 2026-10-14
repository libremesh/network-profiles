const x = ubus.call("lime-location", "get");

if (!x)
	return false;

gauge("node_location_latitude")(null, x.location.lat);
gauge("node_location_longitude")(null, x.location.lon);
