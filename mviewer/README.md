# Mviewer

TODO: UPDATE README

mviewer est une application cartographique initiée et développée par la Région Bretagne, sous le nom de Kartenn (carte en breton).

Le code source de cette application est librement réutilisable depuis 2014.

De nombreuses collectivités mais également des entreprises, le secteur de la recherche et de l’enseignement utilisent librement cette application et participent à son évolution.

## Source Code

* https://github.com/mviewer/mviewer
* https://github.com/mviewer/mviewerstudio

## Requirements

Kubernetes: `>=1.14.0-0`

## Dependencies

None

## Installing the Chart

To install the chart with the release name `mviewer`

```console
helm repo add charts-gs https://camptocamp.github.io/charts-gs/
helm repo update
helm install mviewer charts-gs/mviewer
```

## Uninstalling the Chart

To uninstall the `mviewer` deployment

```console
helm uninstall mviewer
```

The command removes all the Kubernetes components associated with the chart **including persistent volumes** and deletes the release.

## Configuration

Read through the [values.yaml](./values.yaml) file. It has several commented out suggested values.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

```console
helm install mviewer \
  --set replicaCount="2" \
    charts-gs/mviewer
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart.

```console
helm install mviewer charts-gs/mviewer -f values.yaml
```

## mviewer configuration

Through the parameter `configuration.git`, you can set a git repository that will be used for configuring mviewer.

Please refer to the docker documentation for more explanations about this custom configuration: https://mviewerdoc.readthedocs.io/fr/latest/doc_tech/deploy.html#avec-docker

## Values

**Important**: Some values here are not documented because those are obvious parameters that you can find the meaning and the usuability through the Kubernetes configuration: https://kubernetes.io/docs/home/

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image | object | See values.yaml | Set the docker image to use. |
| configuration | object | See values.yaml | [See above](#mviewer-configuration) |
| ingress | object | See values.yaml | Configurations for configuring ingress |

## Changelog

### Version 0.1.0

Initial version
