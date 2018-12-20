#!/bin/bash
# Installation script of Prometheus.
# Will by installed in /opt/prometheus-x.y.z.linux-amd64
# with x.y.z = release

# Define release of prometheus and deduce installation directory
RELEASE=${PROMETHEUS_RELEASE:-2.6.0}
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
[ -h /opt/prometheus ] && rm -f /opt/prometheus && ln -s /opt/$DIR prometheus

# Create configuration directory if necessary
[ -d /etc/prometheus ] || mkdir /etc/prometheus

# Put configuration file if not exists
# Notice that the configuration script should be in the same diretory
# as this script
CURDIR=$(dirname $0)
[ -f /etc/prometheus/prometheus.yaml ] || cp $CURDIR/prometheus.yaml /etc/prometheus/prometheus.yaml

# Had start-stop script




