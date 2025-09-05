# Epinio Helm Chart

From app to URL in one command.

## Introduction

This chart deploys Epinio PaaS on a Kubernetes cluster. It also deploys some of
its dependencies as subcharts.

The documentation is centralized in the [doc website](https://docs.epinio.io).

## Prerequisites

Epinio needs a number of external components to be running on your cluster in order to
work. You may already have those deployed, otherwise follow the instructions here
to deploy them.

Important: Some of the namespaces of the components are hardcoded in the Epinio
code and thus are important to be the same as described here. In the future this
may be configurable on the Epinio Helm chart.

### Ingress Controller

Epinio creates Ingress resources for the API server, the applications and depending
on your setup, the internal container registry. Those resources won't work unless
an Ingress controller is running on your cluster.

If you don't have an Ingress controller already running, you can install Traefik with:

```
$ kubectl create namespace traefik
$ export LOAD_BALANCER_IP=$(LOAD_BALANCER_IP:-) # Set this to the IP of your load balancer if you know that
$ helm install traefik --namespace traefik "https://helm.traefik.io/traefik/traefik-10.3.4.tgz" \
		--set globalArguments='' \
		--set-string ports.web.redirectTo=websecure \
		--set-string ingressClass.enabled=true \
		--set-string ingressClass.isDefaultClass=true \
		--set-string service.spec.loadBalancerIP=$LOAD_BALANCER_IP
```

### Cert Manager

Epinio needs [cert-manager](https://cert-manager.io/) in order to create TLS
certificates for the various Ingresses (see "Ingress controller" above).

If cert-manager is not already installed on the cluster, it can be installed like this:

```
$ kubectl create namespace cert-manager
$ helm repo add jetstack https://charts.jetstack.io
$ helm repo update
$ helm install cert-manager --namespace cert-manager jetstack/cert-manager \
		--set installCRDs=true \
		--set extraArgs[0]=--enable-certificate-owner-ref=true
```

### Kubed

Kubed is installed as a subchart when `.Values.kubed.enabled` is true (default).
If you already have kubed running, you can skip the installation by setting
the helm value "kubed.enabled" to "false".

NOTE: Kubed has been rebranded and is now only available via commercial license. Epinio is using an older version via mirror from the Rancher image registry.

### S3 storage

Epinio is using an S3 compatible storage to store the application source code.

This chart will install [Minio](https://min.io/) when `.Values.minio.enabled` is
true (default).

For additional values that are available, please see the helm chart source: https://github.com/minio/minio/tree/master/helm/minio

This chart will install [s3gw](https://s3gw.io/) when `.Values.s3gw.enabled` is
true.

Any S3 compatible solution can be used instead by setting the aforementioned values
to `false` and using [the values under `s3`](https://github.com/epinio/helm-charts/blob/main/chart/epinio/values.yaml#L44)
to point to the desired S3 server.

For additional values that are available, please see the helm chart source: https://github.com/s3gw-tech/s3gw-charts/tree/main/charts/s3gw

### Container Registry

When Epinio builds a container image for an application from source, it needs
to store that image to a container registry. Epinio installs a container registry
on the cluster when `.Values.containerregistry.enabled` is `true` (default).

Any container registry that supports basic auth authentication can be used (e.g. gcr, dockerhub etc)
instead by setting this value to `false` and using
[the values under `registry`](https://github.com/epinio/helm-charts/blob/main/chart/epinio/values.yaml#L104-L107)
to point to the desired container registry.

The registry image and associated documentation can be found here: https://hub.docker.com/_/registry

## Epinio Staging Workloads

Epinio uses staging workloads to build container images from source code.  As you can imagine, container builds can consume varying amounts of CPU, Memory, and Disk space depending on the application.  Because of this, it is important that these staging workloads can not only specify those resource amounts but also specify scheduling constraints so that your running applications can be protected from any buildtime resource consumption.  For example, you may configure your staging workloads to schedule to a particular node pool within your Kubernetes cluster that is dedicated to builds.

These configurations can be set using the `server.stagingWorkloads` section of the `values.yaml` file with which you may configure the following details:
- Resource Consumption
    - `server.stagingWorkloads.resources`
        - Provide Requests/Limits on CPU & Memory
    - `server.stagingWorkloads.storage`
        - Provide Disk Size parameters for the staging workload's designated PVC
- Scheduling Constraints
    - `server.stagingWorkloads.nodeSelector`
        - Provide Node Selector labels to constrain scheduling to nodes that contain the specified label/value.
    - `server.stagingWorkloads.affinity`
        - Provide Affinity rules to constrain scheduling to nodes that meet the specified criteria.
    - `server.stagingWorkloads.tolerations`
        - Provide Tolerations to allow scheduling to nodes with matching taints.

There exists examples within the `values.yaml` file under the `server.stagingWorkloads` key.  Please review and modify these examples to suit your environmental needs.

The configurations under `server.stagingWorkloads` gets mapped to the build script ConfigMaps which is then processed by the Epinio Server when builds are kicked off.  These specifications are supplied to the newly created staging jobs.

## Install Epinio

If the above dependencies are available or going to be installed by this chart,
Epinio can be installed with the following:

```
$ helm repo add epinio https://epinio.github.io/helm-charts/
$ helm install epinio -n epinio --create-namespace epinio/epinio --values epinio-values.yaml --set global.domain=myepiniodomain.org
```

The only value that is mandatory is the `.Values.global.domain` which
should be a wildcard domain, pointing to the IP address of your running
Ingress controller.
