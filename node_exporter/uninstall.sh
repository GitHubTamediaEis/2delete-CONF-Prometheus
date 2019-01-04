#!/bin/bash
# De-installation script of node_exporter

# Define release of prometheus and deduce installation directory
PROGRAM=node_exporter
RELEASE=${NODE_EXPORTER_RELEASE:-0.17.0}
DIR=$PROGRAM-$RELEASE.linux-amd64

[ -d /opt/$DIR ] && rm -rf /opt/$DIR
[ -h /opt/$PROGRAM ] && rm -f /opt/$PROGRAM

service $PROGRAM stop
chkconfig --del $PROGRAM
[ -f /usr/bin/uninstall-$PROGRAM.sh ] && rm -f /usr/bin/uninstall-$PROGRAM.sh
exit 0
