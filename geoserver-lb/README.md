# About

This helm chart provides a "scaled" version of geOrchestra's GeoServer, at least
int the same way as it was scaled into our former Rancher environments.

It features the following services:

* A synchronization with a remote git repository
* A `Deployment` object for geoserver slaves
* A `geoserver loadbalancer`

The GeoServer slaves' configuration is reloaded whenever a change is detected
into the GeoServer datadir.

This chart requires that a `georchestra` helm release is already deployed.

# Missing

* Resources limits on geoserver-slave pods
