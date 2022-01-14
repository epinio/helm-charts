# Epinio Helm Chart

From app to URL in one command.

## Introduction

This helm chart can be used to deploy Epinio on a cluster. It is an alternative
to `epinio install` command.

## Usage

The doc is centralized in a uniq place, checkout the [doc website](https://docs.epinio.io/installation/install_epinio_with_helm.html).

## Development

    % helm repo add epinio https://epinio.github.io/helm-charts/
    % helm upgrade --install -n epinio --create-namespace --set "skipLinkerd=true" epinio-installer epinio/epinio-installer
    % helm uninstall -n epinio epinio-installer
