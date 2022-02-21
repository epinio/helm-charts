{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "epinio-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "epinio-app.labels" -}}
app.kubernetes.io/managed-by: epinio
app.kubernetes.io/also-managed-by: {{ .Release.Service }}
app.kubernetes.io/created-by: {{ .Values.epinio.username }}
app.kubernetes.io/part-of: {{ .Release.Namespace }}
helm.sh/chart: {{ include "epinio-app.chart" . }}
{{ include "epinio-app.selectorLabels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "epinio-app.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/component: application
{{- end }}
