#!/bin/bash
# Installation script of Prometheus's node exporter
# Will by installed in /opt/node_exporter--amd64
# with x.y.z = release

# Define release of prometheus and deduce installation directory
PROGRAM=node_exporter
RELEASE=${NODE_EXPORTER_RELEASE:-0.17.0}
DIR=$PROGRAM-$RELEASE.linux-amd64
CURDIR=$(dirname $0)

if [ \! -d $DIR ]; then
    URL="https://github.com/prometheus/node_exporter/releases/download/v${RELEASE}/node_exporter-${RELEASE}.linux-amd64.tar.gz"
    wget -O - $URL | tar xfz - -C /opt
    if [ $? != 0 ]; then
	echo "Download of prometheus failed"
	exit 1
    fi
fi

# Handle soft link (/opt/prometheus to /opt/prometheus-x.y.z.linux-amd64)
[ -h /opt/$PROGRAM ] && rm -f /opt/$PROGRAM
ln -s /opt/$DIR /opt/$PROGRAM

# Handle start-stop script
cp $CURDIR/start_stop_$PROGRAM.sh /etc/init.d/$PROGRAM
chmod +x /etc/init.d/$PROGRAM
chkconfig --add $PROGRAM
service $PROGRAM start

# Handle update and uninstall scripts
cp $CURDIR/uninstall.sh /usr/bin/uninstall-$PROGRAM.sh
chmod +x /usr/bin/uninstall-$PROGRAM.sh
