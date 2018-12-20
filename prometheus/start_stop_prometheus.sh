#!/bin/bash
#
# prometheus    Start stop prometheus
#
# chkconfig: 345 20 80
# description: Start, stop script for prometheus

. /etc/init.d/functions

DAEMON=/opt/prometheus/prometheus
CONFIG=/etc/prometheus/prometheus.yaml
TSDBPATH="--storage.tsdb.path /var/lib/prometheus"
TSDBRETENTION="--storage.tsdb.retention 15d"

[ -x $DAEMON ] || exit 0

PID=$(ps -f o ppid,pid,cmd|awk '$1==1 && /'$DAEMON'/{print $2}'

start() {
    echo -n "Starting Prometheus: "
    if [ "x$PID" = "x" ]; then
	daemon $DAEMON $TSDBPATH $TSDBRETENTION --config.file=$CONFIG
	RETVAL=$?
	echo
	return $RETVAL
    else
	echo "prometheus already running: $PID"
	exit 2
    fi
}

stop() {
    echo -n "Stopping Prometheus: "
    if [ "x$PID" = "x" ]; then
	echo "prometheus already stopped"
    else
	killproc -p $PID prometheus
	echo
    fi
    return 0
}

reload() {
    echo -n "Reloading Prometheus: "
    if [ "x$PID" = "x" ]; then
	echo "prometheus not running"
    else
	killproc -p $PID prometheus
	echo
    fi
    return 0
}

case "$1" in
    start)
	start
	;;
    stop)
	stop
	;;
    status)
	status prometheus
	;;
    restart)
	stop
	start
	;;
    reload)
	reload
	;;
    *)
	echo "Usage: $0 {start|stop|status|restart|reload}"
	exit 1
	;;
esac
exit $?

