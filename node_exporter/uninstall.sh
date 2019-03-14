#!/bin/bash
# De-installation script of node_exporter

# Define release of prometheus and deduce installation directory
PROGRAM=node_exporter
RELEASE=${NODE_EXPORTER_RELEASE:-0.17.0}
DIR=$PROGRAM-$RELEASE.linux-amd64

service $PROGRAM stop
chkconfig --del $PROGRAM

[ -h /opt/$PROGRAM ] && rm -f /opt/$PROGRAM
[ -d /opt/$DIR ] && rm -rf /opt/$DIR
[ -d /var/lib/node_exporter ] && rm -rf /var/lib/node_exporter
[ -f /etc/init.d/$PROGRAM ] && rm -f /etc/init.d/$PROGRAM

[ -f /usr/bin/uninstall-$PROGRAM.sh ] && rm -f /usr/bin/uninstall-$PROGRAM.sh
exit 0
