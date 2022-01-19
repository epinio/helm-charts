# Epinio Installer Helm Chart

From app to URL in one command. This chart installs Epinio and all dependencies.

## Introduction

This helm chart can be used to deploy Epinio on a cluster. It includes the [Epinio server helm chart](https://artifacthub.io/packages/helm/epinio/epinio).
It is best used with a fresh cluster.

## Usage

The documentation is centralized in the [doc website](https://docs.epinio.io/installation/installation.html).

## Example

    % helm repo add epinio https://epinio.github.io/helm-charts/
    % helm upgrade --install -n epinio --create-namespace --set "skipLinkerd=true" epinio-installer epinio/epinio-installer
    % helm uninstall -n epinio epinio-installer
