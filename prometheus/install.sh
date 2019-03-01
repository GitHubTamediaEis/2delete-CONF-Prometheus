#!/bin/bash
# Installation script of Prometheus.
# Will by installed in /opt/prometheus-x.y.z.linux-amd64
# with x.y.z = release

# Define release of prometheus and deduce installation directory
RELEASE=${PROMETHEUS_RELEASE:-2.7.1}
DIR=prometheus-$RELEASE.linux-amd64

if [ \! -d $DIR ]; then
    URL="https://github.com/prometheus/prometheus/releases/download/v${RELEASE}/prometheus-${RELEASE}.linux-amd64.tar.gz"
    wget -O - $URL | tar xfz - -C /opt
    if [ $? != 0 ]; then
	echo "Download of prometheus failed"
	exit 1
    fi
fi

# Handle soft link (/opt/prometheus to /opt/prometheus-x.y.z.linux-amd64)
[ -h /opt/prometheus ] && rm -f /opt/prometheus
ln -s /opt/$DIR /opt/prometheus

# Create configuration directory if necessary
[ -d /etc/prometheus ] || mkdir /etc/prometheus
[ -d /etc/prometheus/prometheus_conf.d ] || mkdir /etc/prometheus/prometheus_conf.d


# Put configuration file if not exists
# Notice that the configuration script should be in the same diretory
# as this script
CURDIR=$(dirname $0)
[ -f /etc/prometheus/prometheus.yaml ] || cp $CURDIR/prometheus.yaml /etc/prometheus/prometheus.yaml

# Handle start-stop script
cp $CURDIR/start_stop_prometheus.sh /etc/init.d/prometheus
chmod +x /etc/init.d/prometheus
chkconfig --add prometheus
service prometheus start

# Handle update and uninstall scripts
cp $CURDIR/update-config.sh /usr/bin/update-prometheus-config.sh
chmod +x /usr/bin/update-prometheus-config.sh
cp $CURDIR/uninstall.sh /usr/bin/uninstall-prometheus.sh
chmod +x /usr/bin/uninstall-prometheus.sh
