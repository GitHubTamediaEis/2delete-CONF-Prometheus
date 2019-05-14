#!/bin/bash
# Installation script of Prometheus's yace cloudwatch exporter
# Will by installed in /opt/yace_cloudwatch_exporter-x.y.z-amd64
# with x.y.z = release
#https://search.maven.org/remotecontent?filepath=io/prometheus/cloudwatch/cloudwatch_exporter/$RELEAS/cloudwatch_exporter-$RELEASE-jar-with-dependencies.jar

# Define cloudwatch_exporter installation directory and
PROGRAM=yace_cloudwatch_exporter
BINNAME=yace-linux-amd64
DIR=$PROGRAM-$YACE_CLOUDWATCH_EXPORTER_RELEASE
CFGDIR=/etc/prometheus

CURDIR=$(dirname $0)

if [ \! -d /opt/$DIR ]; then
    mkdir /opt/$DIR
    #URL="https://github.com/ivx/yet-another-cloudwatch-exporter/releases/download/v${YACE_CLOUDWATCH_EXPORTER_RELEASE}/yace-linux-amd64-v$YACE_CLOUDWATCH_EXPORTER_RELEASE"
    URL="https://github.com/ivx/yet-another-cloudwatch-exporter/releases/download/v${YACE_CLOUDWATCH_EXPORTER_RELEASE}/yet-another-cloudwatch-exporter_${YACE_CLOUDWATCH_EXPORTER_RELEASE}_Linux_x86_64.tar.gz"
    #wget -O /opt/$DIR/$BINNAME $URL
    wget -q $URL | tar -xzf -C /opt/$DIR
    if [ $? != 0 ]; then
	echo "Download of $PROGRAM failed"
	exit 1
    fi
    chmod +x /opt/$DIR/$BINNAME
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

# Add logrotation
cp $CURDIR/logrotate_yace_cl_exp /etc/logrotate.d/yace_cloudwatch_exporter
