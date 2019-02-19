#!/bin/bash
# Installation script of Prometheus.
# Will by installed in /opt/alertmanager-x.y.z.linux-amd64
# with x.y.z = release

# Define release of prometheus and deduce installation directory
RELEASE=${ALERTMANAGER_RELEASE:-0.16.1}
DIR=alertmanager-$RELEASE.linux-amd64
-amd64.tar.gz

if [ \! -d $DIR ]; then
    URL="https://github.com/prometheus/alertmanager/releases/download/v${RELEASE}/alertmanager-${RELEASE}.linux-amd64.tar.gz"
    wget -O - $URL | tar xfz - -C /opt
    if [ $? != 0 ]; then
	echo "Download of alertmanager failed"
	exit 1
    fi
fi

# Handle soft link (/opt/prometheus to /opt/prometheus-x.y.z.linux-amd64)
[ -h /opt/alertmanager ] && rm -f /opt/alertmanager
ln -s /opt/$DIR /opt/alertmanager

# Create configuration directory if necessary
[ -d /etc/prometheus ] || mkdir /etc/prometheus

# Put configuration file if not exists
# Notice that the configuration script should be in the same diretory
# as this script
CURDIR=$(dirname $0)
[ -f /etc/prometheus/alertmanager.yml ] || cp $CURDIR/alertmanager.yml /etc/prometheus/alertmanager.yml

# Handle start-stop script
cp $CURDIR/start_stop_alertmanager.sh /etc/init.d/alertmanager
chmod +x /etc/init.d/alertmanager
chkconfig --add alertmanager
service alertmanager start

# Handle update and uninstall scripts
cp $CURDIR/update-config.sh /usr/bin/update-alertmanager-config.sh
chmod +x /usr/bin/update-alertnamager-config.sh
cp $CURDIR/uninstall.sh /usr/bin/uninstall-alertmanager.sh
chmod +x /usr/bin/uninstall-alertmanager.sh
