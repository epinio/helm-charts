#!/bin/bash

set -e

# Install chartmuseum using the gofish package manager
curl -fsSL https://raw.githubusercontent.com/fishworks/gofish/main/scripts/install.sh | bash
gofish init
gofish install chartmuseum

# We need the helm push plugin to automatically package and push chart to our repo
helm plugin install https://github.com/chartmuseum/helm-push.git

# Systemd unit file to start chartmuseum in the runner
cat <<EOF | sudo tee /etc/systemd/system/chartmuseum.service
[Unit]
Description=Helm Chartmuseum
Documentation=https://chartmuseum.com/

[Service]
ExecStart=/usr/local/bin/chartmuseum \\
 --debug \\
 --port=8090 \\
 --storage="local" \\
 --storage-local-rootdir="/home/${USER}/chartstorage/"
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl start chartmuseum

# Waiting chartmuseum initialization
sleep 5

# Add our new ephemeral repo
helm repo add chartmuseum http://localhost:8090
helm repo update

# Push all our charts to the repo
# We force version 0.1.0 because we don't care about versionning
# We only care about testing here
cd chart/
helm cm-push --version "0.1.0" epinio-installer/ chartmuseum
helm cm-push --version "0.1.0" epinio/ chartmuseum
helm cm-push --version "0.1.0" container-registry/ chartmuseum

# Update epinio-installer's values.yaml file for using charts hosted in our repo
sed -i -e 's|containerRegistryChart:.*|containerRegistryChart: "http://host.k3d.internal:8090/charts/container-registry-0.1.0.tgz"|'\
       -e 's|epinioChart:.*|epinioChart: "http://host.k3d.internal:8090/charts/epinio-0.1.0.tgz"|'\
       ../chart/epinio-installer/values.yaml
