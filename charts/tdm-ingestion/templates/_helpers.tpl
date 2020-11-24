{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "tdm-ingestion.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "tdm-ingestion.fullname" -}}
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
{{- define "tdm-ingestion.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "tdm-ingestion.containers" -}}
- name: {{ .Chart.Name }}
  image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  args:
    - {{ .Values.script }}
    {{- if .Values.debug }}
    - -d
    {{- end }}
    - --tdmq_url
    - {{ .Values.tdmq_url }}
  {{- if eq .Values.script  "tdmq_ckan_ingestion.py" }}
    - --bucket
    - {{ .Values.bucket | quote }}
    - --op
    - {{ .Values.operation }}
    - --entity_type
    - {{ .Values.entity_type }}
    - --ckan_url
    - {{ .Values.ckan.url }}
    - --ckan_api_key
    - {{ .Values.ckan.api_key }}
    - --ckan_dataset
    - {{ .Values.ckan.dataset }}
    {{- if .Values.ckan.description }}
    - --ckan_description
    - {{ .Values.ckan.description }}
    {{- end }}
    - --ckan_resource
    - {{ .Values.ckan.resource }}
    - --time_delta_before
    - {{ .Values.time_delta_before }}
    {{- if .Values.upsert }}
    - --upsert
    {{- end }}
    {{- if .Values.prune }}
    - --prune
    {{- end }}
  {{- else }}
    - --bootstrap_server
    - {{.Values.bootstrap_server }}
    - --topics
    - {{ .Values.topics }}
    - --tdmq_auth_token
    - {{ .Values.tdmq_auth_token }}
  {{- end }}
  resources:
    {{- toYaml .Values.resources | nindent 12 }}
{{- end -}}

