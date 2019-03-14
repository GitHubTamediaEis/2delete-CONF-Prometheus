#!/bin/bash
# Installation script of Prometheus's node exporter
# Will by installed in /opt/node_exporter--amd64
# with x.y.z = release

# Define release of prometheus and deduce installation directory
PROGRAM=node_exporter
RELEASE=${NODE_EXPORTER_RELEASE:-0.17.0}
DIR=$PROGRAM-$RELEASE.linux-amd64
CURDIR=$(dirname $0)
BOOLDL=""

# If version of agent are the same --> no download
if [ \! -d /opt/$DIR ]; then
    URL="https://github.com/prometheus/node_exporter/releases/download/v${RELEASE}/node_exporter-${RELEASE}.linux-amd64.tar.gz"
    wget -O - $URL | tar xfz - -C /opt
    BOOLDL="yes"
    if [ $? != 0 ]; then
	    echo "Download of prometheus failed"
	    exit 1
    fi
else
    echo "This directory /opt/$DIR already exists --> no Agent download is required."
fi

# If no difference between init.d scripts from github and current one --> no change --> exit 0
diff -q $CURDIR/start_stop_$PROGRAM.sh /etc/init.d/$PROGRAM > /dev/null
if [[ $? -eq 0 && -n "$BOOLDL" ]]; then
    echo "There is no difference between these 2 files: $CURDIR/start_stop_$PROGRAM.sh /etc/init.d/$PROGRAM"
    echo "exit without action"
    exit 0
else 
    echo "install node_exporter agent process continues (cp start_stop script, ...)"
fi


# Handle soft link (/opt/prometheus to /opt/prometheus-x.y.z.linux-amd64)
[ -h /opt/$PROGRAM ] && rm -f /opt/$PROGRAM
ln -s /opt/$DIR /opt/$PROGRAM

# Handle collector textfile directory with default path: /var/lib/node_exporter/textfile_collector
[ ! -d /var/lib/node_exporter ] && mkdir /var/lib/node_exporter
[ ! -d /var/lib/node_exporter/textfile_collector ] && mkdir /var/lib/node_exporter/textfile_collector

# Handle start-stop script
cp $CURDIR/start_stop_$PROGRAM.sh /etc/init.d/$PROGRAM
chmod +x /etc/init.d/$PROGRAM
chkconfig --add $PROGRAM
service $PROGRAM stop
service $PROGRAM start

# Handle update and uninstall scripts
cp $CURDIR/uninstall.sh /usr/bin/uninstall-$PROGRAM.sh
chmod +x /usr/bin/uninstall-$PROGRAM.sh
