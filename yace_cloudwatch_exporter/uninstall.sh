#!/bin/bash
# De-installation script of yace_cloudwatch_exporter

# Define release of prometheus and deduce installation directory
PROGRAM=yace_cloudwatch_exporter
RELEASE=${YACE_CLOUDWATCH_EXPORTER_RELEASE:-0.12.0}
DIR=$PROGRAM-$RELEASE
CFGFILE=/etc/prometheus/$PROGRAM.yml

/etc/init.d/$PROGRAM stop
chkconfig --del $PROGRAM

[ -d /opt/$DIR ] && rm -rf /opt/$DIR
[ -h /opt/$PROGRAM ] && rm -f /opt/$PROGRAM

[ -f $CFGFILE ] && rm -f $CFGFILE

[ -f /usr/bin/uninstall-$PROGRAM.sh ] && rm -f /usr/bin/uninstall-$PROGRAM.sh
exit 0
