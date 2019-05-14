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

{{- define "flink.volumes" }}
  - name: flink-conf
    configMap:
      name: {{ .Release.Name }}-flink-configmap
{{- if .Values.extraVolumes }}
{{ tpl ( .Values.extraVolumes | toYaml | indent 2) . }}
{{- end }}
{{- end }}

{{- define "flink.volumeMounts" }}
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
    addgroup supergroup
    adduser  flink supergroup

    # here is a subset of lines from docker-entrypoint
    CONF_FILE="${FLINK_HOME}/conf/flink-conf.yaml"
    drop_privs_cmd() {
        if [ $(id -u) != 0 ]; then
            # Don't need to drop privs if EUID != 0
            return
        elif [ -x /sbin/su-exec ]; then
            # Alpine
            echo su-exec flink
        else
            # Others
            echo gosu flink
        fi
    }

    start_server() {
        if [ "$1" = "jobmanager" ]; then
            shift 1
            echo "Starting Job Manager"

            echo "config file: " && grep '^[^\n#]' "${CONF_FILE}"
            exec $(drop_privs_cmd) "$FLINK_HOME/bin/jobmanager.sh" start-foreground "$@"
        elif [ "$1" = "taskmanager" ]; then
            shift 1
            echo "Starting Task Manager"


            if ! grep -E "^taskmanager\.numberOfTaskSlots:.*" "${CONF_FILE}" > /dev/null; then
                TASK_MANAGER_NUMBER_OF_TASK_SLOTS=$(grep -c ^processor /proc/cpuinfo)
                echo "taskmanager.numberOfTaskSlots: ${TASK_MANAGER_NUMBER_OF_TASK_SLOTS}" >> "${CONF_FILE}"
            fi

            echo "config file: " && grep '^[^\n#]' "${CONF_FILE}"
            exec $(drop_privs_cmd) "$FLINK_HOME/bin/taskmanager.sh" start-foreground "$@"
        fi
        exec "$@"
    }

    su flink
    start_server "{{ .Values.command_arg }}"

{{ end }}

{{- define "flink.env" }}
  - name: JOB_MANAGER_RPC_ADDRESS
    value: {{ include "flink.fullname" . }}-jobmanager
{{- if .Values.env }}
{{ .Values.env | toYaml | indent 2 }}
{{- end }}
{{- end }}
