{{/*
Expand the name of the chart.
*/}}
{{- define "georchestra-geoserver.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "georchestra-geoserver.fullname" -}}
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
{{- define "georchestra-geoserver.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "georchestra-geoserver.labels" -}}
helm.sh/chart: {{ include "georchestra-geoserver.chart" . }}
{{ include "georchestra-geoserver.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "georchestra-geoserver.selectorLabels" -}}
app.kubernetes.io/name: {{ include "georchestra-geoserver.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "georchestra-geoserver.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "georchestra-geoserver.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Insert database georchestra environment variables
*/}}
{{- define "georchestra.database-georchestra-envs" -}}
- name: PGHOST
  valueFrom:
    secretKeyRef:
        name: {{ .Values.database.auth.existingSecret }}
        key: host
        optional: false
- name: PGPORT
  valueFrom:
    secretKeyRef:
        name: {{ .Values.database.auth.existingSecret }}
        key: port
        optional: false
- name: PGDATABASE
  valueFrom:
    secretKeyRef:
        name: {{ .Values.database.auth.existingSecret }}
        key: dbname
        optional: false
- name: PGUSER
  valueFrom:
    secretKeyRef:
        name: {{ .Values.database.auth.existingSecret }}
        key: user
        optional: false
- name: PGPASSWORD
  valueFrom:
    secretKeyRef:
        name: {{ .Values.database.auth.existingSecret }}
        key: password
        optional: false
{{- end }}