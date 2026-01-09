{{/*
Insert database environment variables
*/}}
{{- define "datakern.database-envs" -}}
{{- $database := .Values.airflow.postgresql -}}
{{- $database_secret_datakern_name := printf "%s-database-backend" (include "datakern.fullname" .) -}}
{{- if $database.auth.existingSecret }}
{{- $database_secret_datakern_name = $database.auth.existingSecret -}}
{{- end }}
- name: PGHOST
  valueFrom:
    secretKeyRef:
        name: {{ $database_secret_datakern_name }}
        key: host
        optional: false
- name: PGPORT
  valueFrom:
    secretKeyRef:
        name: {{ $database_secret_datakern_name }}
        key: port
        optional: false
- name: PGDATABASE
  valueFrom:
    secretKeyRef:
        name: {{ $database_secret_datakern_name }}
        key: dbname
        optional: false
- name: PGUSER
  valueFrom:
    secretKeyRef:
        name: {{ $database_secret_datakern_name }}
        key: user
        optional: false
- name: PGPASSWORD
  valueFrom:
    secretKeyRef:
        name: {{ $database_secret_datakern_name }}
        key: password
        optional: false
{{- end }}