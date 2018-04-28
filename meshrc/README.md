# meshrc

network profile for [bachelor thesis](https://github.com/aparcar/meshrc) which
allow mesh network monitoring & configuration from a central place.

## node

* Uses the newly introduced
[%m](https://github.com/libremesh/lime-packages/pull/349/) parameter to have
persistent names and IP addresses. Mesh and access points are encrypted. 
* Access point is encrypted
* Mesh is encrypted
* Both disabled on first startup as they eventually retrieve a real config via
  the `meshrc-initial` daemon.
* Activates `prometheus-node-exporter-lua` on all interfaces
