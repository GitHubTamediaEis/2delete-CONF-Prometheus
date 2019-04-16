#!/bin/bash
# De-installation script of yace_cloudwatch_exporter

# Define installation directory
PROGRAM=yace_cloudwatch_exporter
DIR=$PROGRAM-$YACE_CLOUDWATCH_EXPORTER_RELEASE
CFGFILE=/etc/prometheus/$PROGRAM.yml

/etc/init.d/$PROGRAM stop

chkconfig --del $PROGRAM

[ -d /opt/$DIR ] && rm -rf /opt/$DIR
[ -h /opt/$PROGRAM ] && rm -f /opt/$PROGRAM

[ -f $CFGFILE ] && rm -f $CFGFILE

[ -f /etc/init.d/$PROGRAM ] && rm -f /etc/init.d/$PROGRAM

[ -f /usr/bin/uninstall-$PROGRAM.sh ] && rm -f /usr/bin/uninstall-$PROGRAM.sh
exit 0
