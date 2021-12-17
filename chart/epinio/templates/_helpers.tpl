{{- define "registry-url" -}}
{{- if .Values.registryURL -}}
{{ trimSuffix "/" .Values.registryURL }}/
{{- end -}}
{{- end -}}
