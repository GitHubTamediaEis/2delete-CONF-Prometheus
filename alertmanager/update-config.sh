#!/bin/bash
# Update config from github
# Define release of config

# 19.02.2019 Laurent: created but not yet tested

RELEASE=${CONFIG_RELEASE:-0.3}
DIR=CONF-alertmanager-${RELEASE}
. /etc/Tamedia

cd
wget -O - https://github.com/GitHubTamediaEis/CONF-Prometheus/archive/v${RELEASE}.tar.gz|tar xfz -

# Test if update needed (if yes, update S3 bucket and apply new config)
if ! cmp -s /etc/prometheus/alertmanager.yaml $DIR/alertmanager/alertmanager.yaml; then
    aws s3 cp --recursive $DIR s3://${AppBucket}/alertmanager
    cp $DIR/alertmanager/alertmanager.yaml /etc/prometheus/alertmanager.yaml
    service alertmanager reload

fi
rm -rf $DIR
