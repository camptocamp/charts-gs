# How to publish a new version of an helm chart

1. Make your changes
2. Change the version in the Chart.yaml
3. Push your code

# How to create a new helm chart

1. Create a new folder with the name of your helm chart
2. Do your changes inside the folder
3. Make sure to add it to dependabot: [dependabot.yml](https://github.com/camptocamp/charts-gs/blob/main/.github/dependabot.yml)
4. Push your code

# WARNING: New location storage for the helm chart - How to use

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
