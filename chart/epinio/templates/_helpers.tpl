{{/*
URL prefix for container images to be compatible with Rancher
*/}}
{{- define "registry-url" -}}
{{- if .Values.registryURL -}}
{{ trimSuffix "/" .Values.registryURL }}/
{{- end -}}
{{- end -}}

{{/*
URL of the registry epinio uses to store workload images
*/}}
{{- define "epinio.registry-url" -}}
{{- if .Values.containerregistry.enabled -}}
{{-   print "registry.epinio-staging.svc.cluster.local:5000" }}
{{- else -}}
{{-   print .Values.global.registryURL }}
{{- end -}}
{{- end -}}
