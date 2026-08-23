{{- define "myapp-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "myapp-chart.fullname" -}}
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

{{- define "myapp-chart.labels" -}}
helm.sh/chart: {{ include "myapp-chart.name" . }}-{{ .Chart.Version | replace "+" "_" }}
{{ include "myapp-chart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/namespace: {{ .Release.Namespace }}
{{- end }}

{{- define "myapp-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "myapp-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}