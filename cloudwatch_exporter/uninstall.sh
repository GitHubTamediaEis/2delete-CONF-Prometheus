#!/bin/bash
# De-installation script of cloudwatch_exporter

# Define release of prometheus and deduce installation directory
PROGRAM=cloudwatch_exporter
RELEASE=${CLOUDWATCH_EXPORTER_RELEASE:-0.5.0}
DIR=$PROGRAM-$RELEASE

service $PROGRAM stop
chkconfig --del $PROGRAM
[ -f /etc/init.d/$PROGRAM ] && rm -f /etc/init.d/$PROGRAM

[ -d /opt/$DIR ] && rm -rf /opt/$DIR
[ -h /opt/$PROGRAM ] && rm -f /opt/$PROGRAM

[ -f /etc/$PROGRAM.yaml ] && rm -f /etc/$PROGRAM.yaml
[ -f /usr/bin/uninstall-$PROGRAM.sh ] && rm -f /usr/bin/uninstall-$PROGRAM.sh

exit 0
