#!/bin/bash
# Update config from github

# 19.02.2019 Laurent: created but not yet tested

DIR=CONF-alertmanager-${CONFIG_RELEASE}
. /etc/myawsenv

cd
wget -O - https://github.com/GitHubTamediaEis/CONF-Prometheus/archive/v${CONFIG_RELEASE}.tar.gz|tar xfz -

# Test if update needed (if yes, update S3 bucket and apply new config)
if ! cmp -s /etc/prometheus/alertmanager.yaml $DIR/alertmanager/alertmanager.yaml; then
    aws s3 cp --recursive $DIR s3://${AppBucket}/alertmanager
    cp $DIR/alertmanager/alertmanager.yaml /etc/prometheus/alertmanager.yaml
    service alertmanager reload

fi
rm -rf $DIR
