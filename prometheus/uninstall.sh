#!/bin/bash
# De-installation script of Prometheus.

# Define release of prometheus and deduce installation directory
RELEASE=${PROMETHEUS_RELEASE:-2.6.0}
DIR=prometheus-$RELEASE.linux-amd64

[ -d /opt/$DIR ] && rm -rf /opt/$DIR
[ -h /opt/prometheus ] && rm -f /opt/prometheus
[ -d /etc/prometheus ] && rm -rf /etc/prometheus

service prometheus stop
chkconfig --del prometheus
[ -f /etc/init.d/prometheus] && rm -f /etc/init.d/prometheus
[ -f /usr/bin/update-prometheus-config.sh] && rm -f /usr/bin/update-prometheus-config.sh
[ -f /usr/bin/uninstall-prometheus.sh] && rm -f /usr/bin/uninstall-prometheus.sh
exit 0
