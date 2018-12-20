#!/bin/bash
VERSION=$(cat VERSION)
TGZNAME=prometheus-${VERSION}.tar.gz
FILES="
install-prometheus-echosystem.sh
echosystem-versions.sh
prometheus/install.sh
prometheus/prometheus.yaml
prometheus/start_stop_prometheus.sh
"
tar cfz .build/$TGZNAME $FILES
# upload $TGZNAME to github
# owner=GitHubTamediaEis
# repo=CONF-Prometheus
# id=download
# https://uploads.github.com/repos/$owner/$repo/releases/$id/assets?name=$(basename $filename)
