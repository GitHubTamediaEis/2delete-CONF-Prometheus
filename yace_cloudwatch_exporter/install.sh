#!/bin/bash
# Installation script of Prometheus's yace cloudwatch exporter
# Will by installed in /opt/yace_cloudwatch_exporter-x.y.z-amd64
# with x.y.z = release
#https://search.maven.org/remotecontent?filepath=io/prometheus/cloudwatch/cloudwatch_exporter/$RELEAS/cloudwatch_exporter-$RELEASE-jar-with-dependencies.jar

# Define release of cloudwatch_exporter and deduce installation directory and
# jar file name (cloudwatch_exporter is a java program)
PROGRAM=yace_cloudwatch_exporter
RELEASE=${YACE_CLOUDWATCH_EXPORTER_RELEASE:-0.12.0}
DIR=$PROGRAM-$RELEASE
CFGDIR=/etc/prometheus

CURDIR=$(dirname $0)

if [ \! -d /opt/$DIR ]; then
    mkdir /opt/$DIR
    URL="https://github.com/ivx/yet-another-cloudwatch-exporter/releases/download/0.12.0/yace-linux-amd64-0.12.0"
    wget -O /opt/$DIR/. $URL
    if [ $? != 0 ]; then
	echo "Download of $PROGRAM failed"
	exit 1
    fi
fi

# Handle soft link (/opt/$PROGRAM to /opt/$PROGRAM-x.y.z...)
[ -h /opt/$PROGRAM ] && rm -f /opt/$PROGRAM
ln -s /opt/$DIR /opt/$PROGRAM

# Put configuration file if not exists
# Notice that the configuration script should be in the same diretory
# as this script
[ -d $CFGDIR ] || mkdir $CFGDIR 
[ -f $CFGDIR/$PROGRAM.yml ] || cp $CURDIR/$PROGRAM.yml $CFGDIR/$PROGRAM.yml

# Handle start-stop script
cp $CURDIR/start_stop_$PROGRAM.sh /etc/init.d/$PROGRAM
chmod +x /etc/init.d/$PROGRAM
chkconfig --add $PROGRAM
service $PROGRAM start

# Handle update and uninstall scripts
cp $CURDIR/uninstall.sh /usr/bin/uninstall-$PROGRAM.sh
chmod +x /usr/bin/uninstall-$PROGRAM.sh
