{{- define "registry-url" -}}
{{- if .Values.registryURL -}}
{{- printf "%s/" .Values.registryURL -}}
{{- end -}}
{{- end -}}
