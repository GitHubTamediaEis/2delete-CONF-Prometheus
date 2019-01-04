#!/bin/bash
# Installation script of Prometheus's cloudwatch exporter
# Will by installed in /opt/cloudwatch_exporter-x.y.z-amd64
# with x.y.z = release
#https://search.maven.org/remotecontent?filepath=io/prometheus/cloudwatch/cloudwatch_exporter/$RELEAS/cloudwatch_exporter-$RELEASE-jar-with-dependencies.jar

# Define release of cloudwatch_exporter and deduce installation directory and
# jar file name (cloudwatch_exporter is a java program)
PROGRAM=cloudwatch_exporter
RELEASE=${CLOUDWATCH_EXPORTER_RELEASE:-0.5.0}
DIR=$PROGRAM-$RELEASE
JAR=$PROGRAM-jar-with-dependencies.jar

CURDIR=$(dirname $0)

if [ \! -d /opt/$DIR ]; then
    mkdir /opt/$DIR
    URL="https://search.maven.org/remotecontent?filepath=io/prometheus/cloudwatch/cloudwatch_exporter/$RELEASE/$DIR-jar-with-dependencies.jar"
    wget -O /opt/$DIR/$JAR $URL
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
[ -f /etc/$PROGRAM.yaml ] || cp $CURDIR/$PROGRAM.yaml /etc/$PROGRAM.yaml

# Handle start-stop script
cp $CURDIR/start_stop_$PROGRAM.sh /etc/init.d/$PROGRAM
chmod +x /etc/init.d/$PROGRAM
chkconfig --add $PROGRAM
service $PROGRAM start

# Handle update and uninstall scripts
cp $CURDIR/uninstall.sh /usr/bin/uninstall-$PROGRAM.sh
chmod +x /usr/bin/uninstall-$PROGRAM.sh
