#!/bin/bash
# De-installation script of Node_Exporter.

# Define release of node_exporter and deduce installation directory
RELEASE=${NODE_EXPORTER_RELEASE:-0.17.0}
DIR=node_exporter-$RELEASE.linux-amd64

[ -d /opt/$DIR ] && rm -rf /opt/$DIR
[ -h /opt/node_exporter ] && rm -f /opt/node_exporter

service node_exporter stop
chkconfig --del node_exporter
[ -f /etc/init.d/node_exporter] && rm -f /etc/init.d/node_exporter
[ -f /usr/bin/update-node_exporter-config.sh] && rm -f /usr/bin/update-node_exporter-config.sh
[ -f /usr/bin/uninstall-node_exporter.sh] && rm -f /usr/bin/uninstall-node_exporter.sh
exit 0
