#!/bin/bash
#
# prometheus    Start stop prometheus
#
# chkconfig: 345 20 80
# description: Start, stop script for prometheus
# processname: prometheus

PROGNAME=prometheus
DAEMON=/opt/prometheus/$PROGNAME
CONFIG=/etc/prometheus/prometheus.yaml
LOGFILE=/var/log/prometheus.log

TSDBPATH="--storage.tsdb.path /var/lib/prometheus"
#TSDBRETENTION="--storage.tsdb.retention 15d"	### [DEPRECATED] --> --storage.tsdb.retention.time
TSDBRETENTION="--storage.tsdb.retention.time 31d"

[ -x $DAEMON ] || exit 0

PID=$(ps -e -o ppid,pid,cmd|awk '$1==1 && /'$(echo $DAEMON|tr / .)'/ {print $2}')

start() {
    echo -n "Starting Prometheus: "
    if [ "x$PID" = "x" ]; then
	$DAEMON $TSDBPATH $TSDBRETENTION --web.enable-admin-api --config.file=$CONFIG > $LOGFILE < /dev/null 2>&1 &
	RETVAL=$?
	echo "started"
	return $RETVAL
    else
	echo "prometheus already running: $PID"
	return 2
    fi
}

stop() {
    echo -n "Stopping Prometheus: "
    if [ "x$PID" = "x" ]; then
	echo "prometheus already stopped"
    else
	kill -TERM $PID
	kill -0 $PID
	echo "prometheus stopped"
    fi
    return 0
}

status() {
    if [ "x$PID" = "x" ]; then
	echo "prometheus not running"
    else
	echo "prometheus running at $PID"
    fi
    return 0
}

reload() {
    echo -n "Reloading Prometheus: "
    if [ "x$PID" = "x" ]; then
	echo "prometheus not running"
    else
	kill -HUP $PID
	echo "prometheus reloaded"
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
	status
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

