#!/bin/bash
# De-installation script of Prometheus.

# Define installation directory
DIR=prometheus-$PROMETHEUS_RELEASE.linux-amd64

service prometheus stop
chkconfig --del prometheus

[ -d /opt/$DIR ] && rm -rf /opt/$DIR
[ -h /opt/prometheus ] && rm -f /opt/prometheus
[ -d /etc/prometheus ] && rm -rf /etc/prometheus

[ -f /etc/init.d/prometheus ] && rm -f /etc/init.d/prometheus
[ -f /usr/bin/update-prometheus-config.sh ] && rm -f /usr/bin/update-prometheus-config.sh
[ -f /usr/bin/uninstall-prometheus.sh ] && rm -f /usr/bin/uninstall-prometheus.sh
exit 0
