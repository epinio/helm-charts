# Grafana Cloud observability for Epinio

Deploys Grafana Alloy to ship pod logs (Loki) and cluster metrics (Prometheus) to Grafana Cloud.

## Enable via Epinio chart

Short flags (telemetry-style):

```bash
helm upgrade --install epinio chart/epinio -n epinio --create-namespace \
  --set global.domain=example.com \
  --set observability.enabled=true \
  --set observability.clusterName=my-cluster \
  --set-string observability.grafanaCloud.token=glc_... \
  --set observability.grafanaCloud.lokiUrl=https://logs-....grafana.net/loki/api/v1/push \
  --set-string observability.grafanaCloud.lokiUsername=LOKI_USER \
  --set observability.grafanaCloud.prometheusUrl=https://prometheus-....grafana.net/api/prom/push \
  --set-string observability.grafanaCloud.prometheusUsername=PROM_USER
```

Or a small values file:

```yaml
observability:
  enabled: true
  clusterName: my-cluster
  grafanaCloud:
    token: glc_...
    lokiUrl: https://logs-....grafana.net/loki/api/v1/push
    lokiUsername: "LOKI_USER"
    prometheusUrl: https://prometheus-....grafana.net/api/prom/push
    prometheusUsername: "PROM_USER"
```

Use `--set-string` for Loki/Prometheus usernames so YAML does not turn them into floats.

## Standalone

```bash
helm upgrade --install grafana-cloud chart/grafana-cloud-observability \
  -n monitoring --create-namespace \
  --set clusterName=my-cluster \
  --set-string grafanaCloud.token=glc_... \
  --set grafanaCloud.lokiUrl=... \
  --set-string grafanaCloud.lokiUsername=... \
  --set grafanaCloud.prometheusUrl=... \
  --set-string grafanaCloud.prometheusUsername=...
```
