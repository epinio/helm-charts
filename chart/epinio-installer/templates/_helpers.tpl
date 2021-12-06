{{- define "epinio.installerImage" -}}
{{- if .Values.installerImageOverride -}}
{{- .Values.installerImageOverride -}}
{{- else -}}
{{- printf "ghcr.io/epinio/epinio-installer:%s" .Chart.AppVersion -}}
{{- end -}}
{{- end -}}
