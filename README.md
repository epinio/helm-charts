<img src="./assets/epinio.png" align="right" width="200" height="50%">

## Usage

[Helm](https://helm.sh) must be installed to use the chart.  Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

    helm repo add epinio-helm-chart https://epinio.github.io/epinio-helm-chart

If you had already added this repo earlier, run `helm repo update` to fetch
the latest versions of the package. You can then run `helm search repo
epinio-helm-chart` to see the chart.

To install the epinio chart:

    helm install my-epinio epinio-helm-chart/epinio

At the end of the installation, usefull information will be printed to help you to start working with your fresh Epinio deployment.

To uninstall the chart:

    helm delete my-epinio

## Helm chart repo

This repo is also used as Helm chart repository by publishing the index.yaml through github-pages feature.
https://epinio.github.io/epinio-helm-chart/index.yaml

We are using the chart-releaser-action github action to automatically publish the new chart version when an epinio release is out.
