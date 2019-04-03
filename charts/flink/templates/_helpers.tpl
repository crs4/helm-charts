{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "flink.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "flink.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "flink.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "flink.volumes" -}}
volumes:
  - name: flink-conf
    configMap:
      name: {{ .Release.Name }}-flink-configmap
{{- if .Values.extraVolumes }}
{{ tpl ( .Values.extraVolumes | toYaml | indent 2) . }}
{{- end }}
{{- end }}

{{- define "flink.volumeMounts" -}}
volumeMounts:
  - name: flink-conf
    mountPath: /tmp/conf
{{- if .Values.extraVolumeMounts }}
{{ tpl ( .Values.extraVolumeMounts | toYaml | indent 2) . }}
{{- end }}
{{- end }}

{{- define "flink.command" -}}
command:
  - /bin/sh
  - "-c"
  - |
    ln -s -f /tmp/conf/flink-conf.yaml /opt/flink/conf
    /docker-entrypoint.sh {{ .Values.command_arg }}

{{ end }}

{{- define "flink.env" }}
env:
  - name: JOB_MANAGER_RPC_ADDRESS
    value: {{ include "flink.fullname" . }}-jobmanager
{{- if .Values.env }}
{{ .Values.env | toYaml | indent 2 }}
{{- end }}
{{- end }}
