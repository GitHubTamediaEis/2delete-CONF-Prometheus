#!/bin/bash
# Update config from github
DIR=CONF-Prometheus-${CONFIG_RELEASE}
. /etc/myawsenv

cd
wget -O - https://github.com/GitHubTamediaEis/CONF-Prometheus/archive/v${CONFIG_RELEASE}.tar.gz|tar xfz -

# Test if update needed (if yes, update S3 bucket and apply new config)
if ! cmp -s /etc/prometheus/prometheus.yaml $DIR/prometheus/prometheus.yaml; then
    aws s3 cp --recursive $DIR s3://${AppBucket}/Prometheus
    cp $DIR/prometheus/prometheus.yaml /etc/prometheus/prometheus.yaml
    service prometheus reload

fi
rm -rf $DIR
