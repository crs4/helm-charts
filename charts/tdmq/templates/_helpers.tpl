{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "tdmq.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "tdmq.fullname" -}}
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
{{- define "tdmq.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return true if a secret object should be created
*/}}
{{- define "tdmq.createSecret" -}}
{{- if .Values.existingSecret -}}
{{- else -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return tdmq.adminToken password
*/}}
{{- define "tdmq.adminToken" -}}
{{- if .Values.conf.adminToken -}}
    {{- .Values.conf.adminToken -}}
{{- else -}}
    {{- randAlphaNum 32 -}}
{{- end -}}
{{- end -}}

{{/*
Generate a vfs configuration dictionary
*/}}
{{- define "tdmq.vfsConfig" -}}
{
'storage.root': {{ required "Storage root is required" .storageRoot | quote }},
'config': {
  {{- if not (hasKey . "vfs.s3.endpoint_override") -}}
    {{- fail "S3 endpoint is required" -}}
  {{- end -}}
  {{- range $k, $v := . }}
  {{- if (or (hasPrefix "vfs" $k) (hasPrefix "sm" $k)) }}
  {{ $k | quote }}: {{ $v | quote }},
  {{- end }}
  {{- end -}}
},
'credentials': {
  "vfs.s3.aws_access_key_id": {{ required "AWS access key for internal VFS is required" .awsAccessKey | quote }},
  "vfs.s3.aws_secret_access_key": {{ required "AWS secret access key for internal VFS is required" .awsSecretAccessKey | quote }},
  }
}
{{- end -}}
