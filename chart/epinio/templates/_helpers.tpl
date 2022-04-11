{{/*
URL prefix for container images to be compatible with Rancher
*/}}
{{- define "registry-url" -}}
{{- if .Values.global.cattle.systemDefaultRegistry -}}
{{ trimSuffix "/" .Values.global.cattle.systemDefaultRegistry }}/
{{- end -}}
{{- end -}}

{{/*
URL of the registry epinio uses to store workload images
*/}}
{{- define "epinio.registry-url" -}}
{{- if .Values.containerregistry.enabled -}}
{{-   printf "registry.%s.svc.cluster.local:5000" .Release.Namespace }}
{{- else -}}
{{-   print .Values.global.registryURL }}
{{- end -}}
{{- end -}}

{{/*
URL of the minio epinio installed
*/}}
{{- define "epinio.minio-url" -}}
{{- if .Values.minio.enabled -}}
{{-   printf "%s.%s.svc.cluster.local:9000" .Values.minio.fullnameOverride .Release.Namespace }}
{{- else -}}
{{-   print .Values.s3.endpoint }}
{{- end -}}
{{- end -}}

{{/*
Host name of the minio epinio installed
*/}}
{{- define "epinio.minio-hostname" -}}
{{- printf "%s.%s.svc.cluster.local" .Values.minio.fullnameOverride .Release.Namespace }}
{{- end -}}
