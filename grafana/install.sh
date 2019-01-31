#!/bin/bash
# Installation script of Grafana.
# install a RPM package through yum

# Define  installation directory
INSTALLDIR=/tmp/grafana

if [ `rpm -qa |grep -i grafana-|wc -l` -eq 0 ]; then
    URL="https://dl.grafana.com/oss/release/grafana-5.4.3-1.x86_64.rpm"
    yum install $URL
    if [ $? != 0 ]; then
	    echo "yum instal $URL failed"
	    exit 1
    fi
fi

# Create configuration directory if necessary
[ -d /etc/grafana ] || mkdir /etc/grafana

# Put configuration file if not exists
# Notice that the configuration script should be in the same diretory
# as this script
#CURDIR=$(dirname $0)
#[ -f /etc/prometheus/prometheus.yaml ] || cp $CURDIR/prometheus.yaml /etc/prometheus/prometheus.yaml

# Handle start-stop script
service grafana start

# Handle update and uninstall scripts
#cp $CURDIR/update-config.sh /usr/bin/update-prometheus-config.sh
#chmod +x /usr/bin/update-prometheus-config.sh
#cp $CURDIR/uninstall.sh /usr/bin/uninstall-grafana.sh
#chmod +x /usr/bin/uninstall-grafana.sh
