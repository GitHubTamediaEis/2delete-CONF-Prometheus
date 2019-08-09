#!/bin/bash
# Installation script of Prometheus.
# Will by installed in /opt/prometheus-x.y.z.linux-amd64
# with x.y.z = release

# Define installation directory
DIR=prometheus-$PROMETHEUS_RELEASE.linux-amd64
CFGFILE=/etc/prometheus/prometheus.yaml
# Must be <*>.sh to be used by /etc/profile
ALIASFILE=/etc/profile.d/prometheus_check_config.sh
SCRIPTDIR=/opt/prometheus_scripts
SCRIPTPROC=prometheus_check_proc.sh

if [ \! -d $DIR ]; then
    URL="https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_RELEASE}/prometheus-${PROMETHEUS_RELEASE}.linux-amd64.tar.gz"
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
[ -f $CFGFILE ] || cp $CURDIR/prometheus.yaml $CFGFILE

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

# Add Prometheus check config alias
echo "# Created during the Prometheus installation: check validity of configuration of Prometheus" > $ALIASFILE
echo "alias prom_chk_config='/opt/prometheus/promtool check config /etc/prometheus/prometheus.yaml'" >> $ALIASFILE

# Add scripts and schedule them
[ -d $SCRIPTDIR ] || mkdir $SCRIPTDIR
cp $CURDIR/prometheus_check_proc.sh $SCRIPTDIR/.
croncmd="$SCRIPTDIR/$SCRIPTPROC"
chmod 755 $croncmd
cronjob="*/1 * * * * $croncmd"
( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -

# Add logrotation
cp $CURDIR/logrotate_prometheus /etc/logrotate.d/prometheus
