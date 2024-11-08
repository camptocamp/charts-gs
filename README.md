# WARNING: New location storage for the helm chart

All the helm chart are now stored inside the GitHub Docker registry.

Please use it like so:

## For helmfile.yaml

```
chart: oci://ghcr.io/camptocamp/charts-gs/myhelmchart
version: X.X.X
```

You don't need to include this anymore:
```
repositories:
  - name: charts-gs
    url: https://camptocamp.github.io/charts-gs/
```

Make sure to migrate to this new way of working.

## When installing manually

```
helm install myapp oci://ghcr.io/camptocamp/charts-gs/myhelmchart --version X.X.X
```