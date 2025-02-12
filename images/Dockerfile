# Download tools
FROM busybox:latest AS downloader

RUN wget https://get.helm.sh/helm-v3.9.0-linux-amd64.tar.gz -O helm.tar.gz
RUN mkdir helm
RUN tar xvf helm.tar.gz -C helm
RUN mv helm/*/helm /bin/helm


## Build the actual container
FROM ghcr.io/k3d-io/k3d:5.7

ARG VERSION
ENV EPINIO_HELM_CHART_VERSION $VERSION

COPY --from=downloader /bin/helm /usr/local/bin/helm

ADD startup.sh /startup.sh

ENTRYPOINT ["/startup.sh"]
