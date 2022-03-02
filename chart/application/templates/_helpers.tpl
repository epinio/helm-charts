{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "epinio-application.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "epinio-application.labels" -}}
app.kubernetes.io/managed-by: epinio
app.kubernetes.io/created-by: {{ .Values.epinio.username }}
app.kubernetes.io/part-of: {{ .Release.Namespace }}
helm.sh/chart: {{ include "epinio-application.chart" . }}
{{ include "epinio-application.selectorLabels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "epinio-application.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.epinio.appName }}
app.kubernetes.io/component: application
{{- end }}

{{/*
Resource name truncation while keeping it unique. Keep as-is when short enough.
Else compute a 32-char hash and affix it to the suitably truncated base.
*/}}
{{- define "epinio-truncate" -}}
{{ ternary . (print (trunc 30 .) "-" (trunc 31 (sha256sum .))) (lt (len .) 64) }}
{{- end }}
