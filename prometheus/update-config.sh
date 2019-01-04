#!/bin/bash
# Update config from github
# Define release of config
RELEASE=${CONFIG_RELEASE:-0.3}
DIR=CONF-Prometheus-${RELEASE}
. /etc/Tamedia

cd
wget -O - https://github.com/GitHubTamediaEis/CONF-Prometheus/archive/v${RELEASE}.tar.gz|tar xfz -

# Test if update needed (if yes, update S3 bucket and apply new config)
if ! cmp -s /etc/prometheus/prometheus.yaml $DIR/prometheus/prometheus.yaml; then
    aws s3 cp --recursive $DIR ${AppBucket}/Prometheus
    cp $DIR/prometheus/prometheus.yaml /etc/prometheus/prometheus.yaml
    service prometheus reload

fi
rm -rf $DIR
