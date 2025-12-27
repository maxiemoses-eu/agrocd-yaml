{{- define "user.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{- define "user.labels" -}}
app.kubernetes.io/name: {{ include "user.name" . }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
{{- end }}

{{- define "user.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{- define "user.selectorLabels" -}}
app.kubernetes.io/name: {{ include "user.name" . }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end }}
