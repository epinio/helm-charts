{{- define "grafana-cloud-observability.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "grafana-cloud-observability.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := include "grafana-cloud-observability.name" . -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "grafana-cloud-observability.labels" -}}
app.kubernetes.io/name: {{ include "grafana-cloud-observability.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" }}
{{- end -}}

{{- define "grafana-cloud-observability.tokenSecretName" -}}
{{- if .Values.grafanaCloud.existingSecret -}}
{{- .Values.grafanaCloud.existingSecret -}}
{{- else -}}
{{- printf "%s-token" (include "grafana-cloud-observability.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/* Force Grafana Cloud numeric IDs to plain strings (avoid 1.765145e+06 from YAML floats). */}}
{{- define "grafana-cloud-observability.plainString" -}}
{{- $v := . -}}
{{- if kindIs "float64" $v -}}
{{- printf "%.0f" $v -}}
{{- else if kindIs "float32" $v -}}
{{- printf "%.0f" $v -}}
{{- else if kindIs "int" $v -}}
{{- printf "%d" $v -}}
{{- else if kindIs "int64" $v -}}
{{- printf "%d" $v -}}
{{- else -}}
{{- $v | toString -}}
{{- end -}}
{{- end -}}
