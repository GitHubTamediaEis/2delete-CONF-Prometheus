#!/bin/bash
# De-installation script of cloudwatch_exporter

# Define installation directory
PROGRAM=cloudwatch_exporter
DIR=$PROGRAM-$CLOUDWATCH_EXPORTER_RELEASE

service $PROGRAM stop
chkconfig --del $PROGRAM
[ -f /etc/init.d/$PROGRAM ] && rm -f /etc/init.d/$PROGRAM

[ -d /opt/$DIR ] && rm -rf /opt/$DIR
[ -h /opt/$PROGRAM ] && rm -f /opt/$PROGRAM

[ -f /etc/$PROGRAM.yaml ] && rm -f /etc/$PROGRAM.yaml
[ -f /usr/bin/uninstall-$PROGRAM.sh ] && rm -f /usr/bin/uninstall-$PROGRAM.sh

exit 0
