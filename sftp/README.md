# Where this SFTP image has been Built from ?

See [here for the details](https://github.com/camptocamp/georchestra-sftp/blob/k8s-bullseye/README.md).

# Scaleway load balancer annotations

You can use the following [annotations](https://github.com/scaleway/scaleway-cloud-controller-manager/blob/master/docs/loadbalancer-annotations.md) to fine tune the external load balancer
created by scaleway :

```yaml
service.beta.kubernetes.io/scw-loadbalancer-externally-managed: "true"
service.beta.kubernetes.io/scw-loadbalancer-id: fr-par-1/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```
