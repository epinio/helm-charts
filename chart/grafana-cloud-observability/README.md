# Grafana Cloud observability for Epinio

Chart defaults for collectors and telemetry services. **User config is in epinio-helper**, not here.

## Configure (epinio-helper)

| File | Purpose |
|------|---------|
| `observability-config.yaml` | Fleet, Loki, Prometheus URLs, cluster name |
| `observability-secrets.yaml` | `glc_` token |
| `epinio-values.yaml` | Epinio only (domain, server) — **not** used for Grafana |

## Install

```bash
cd Desktop/epinio-helper
cp observability-secrets.yaml.example observability-secrets.yaml
# edit observability-config.yaml + observability-secrets.yaml

./install-grafana-cloud-observability.sh
```

The script reads epinio-helper config and merges with this chart's `values.yaml` (collectors, telemetry services).

## Verify

```bash
kubectl get pods -n monitoring
```

**Loki:** `{namespace="epinio", container="buildpack"}`

**Prometheus:** `count(kube_pod_status_phase{namespace="workspace", phase="Running"})`
