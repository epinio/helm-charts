## Build locally

Build this image:

```
docker build -t epiniod --build-arg VERSION=1.0.0 .
```

(set the VERSION build arg to the version of the chart that this image should use)

Run it:

```
docker run --name epiniod -it --privileged -p 443:443 epiniod
```

Visit https://epinio.127.0.0.1.sslip.io in your browser

## Build in CI

We provide a [pipeline](https://github.com/epinio/helm-charts/blob/main/.github/workflows/build-epiniod.yml) that builds the image for the latest released chart.
This can be manually triggered (with workflow dispatch) here: https://github.com/epinio/helm-charts/actions/workflows/build-epiniod.yml

The built image can be run in a similar way as above, but pointing to the public image:

```
docker run --name epiniod -it --privileged -p 443:443 ghcr.io/epinio/epiniod:1.2.1
```
