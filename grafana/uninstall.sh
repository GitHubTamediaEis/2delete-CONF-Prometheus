#!/bin/bash
# De-installation script of Grafana.

# Stop grafana
chkconfig --del grafana-server
service grafana-server stop

# Erase Grafana rpm package
[ `rpm -qa |grep -i grafana-|wc -l` -eq 1 ] && rpm -e grafana

# Remove grafana data
[ -d /var/lib/grafana ] && rm -rf /var/lib/grafana

# Remove grafana dir in /etc
[ -d /etc/grafana ] && rm -rf /etc/grafana

exit 0
