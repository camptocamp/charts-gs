{{/*
Expand the name of the chart.
*/}}
{{- define "geocontrib.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "geocontrib.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "geocontrib.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "geocontrib.labels" -}}
helm.sh/chart: {{ include "geocontrib.chart" . }}
{{ include "geocontrib.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "geocontrib.selectorLabels" -}}
app.kubernetes.io/name: {{ include "geocontrib.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "geocontrib.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "geocontrib.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Backend healthcheck path, honoring the URL_PREFIX env variable
*/}}
{{- define "geocontrib.healthPath" -}}
{{- $prefix := "" -}}
{{- range .Values.env_variables }}
{{- if eq .name "URL_PREFIX" }}{{ $prefix = .value | default "" | trimPrefix "/" }}{{ end }}
{{- end -}}
/{{ $prefix }}api/flat-pages/
{{- end }}

{{/*
Host header for backend healthchecks: first entry of the ALLOWED_HOSTS env
variable, so Django accepts the probe request. Falls back to localhost
(part of Django's default ALLOWED_HOSTS)
*/}}
{{- define "geocontrib.healthHost" -}}
{{- $host := "" -}}
{{- range .Values.env_variables }}
{{- if and (eq .name "ALLOWED_HOSTS") .value }}{{ $host = splitList "," .value | first | trim | trimPrefix "." }}{{ end }}
{{- end -}}
{{- if or (not $host) (eq $host "*") }}{{ $host = "localhost" }}{{ end -}}
{{- $host -}}
{{- end }}
