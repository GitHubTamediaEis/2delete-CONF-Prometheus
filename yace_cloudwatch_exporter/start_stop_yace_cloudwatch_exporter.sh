#!/bin/bash
#
# yace_cloudwatch_exporter    Start stop yace_cloudwatch_exporter
#
# chkconfig: 345 20 80
# description: Start, stop script for yace_cloudwatch_exporter
# processname: yace_cloudwatch_exporter
# Version: 0.12.0

PROGNAME=yace-linux-amd64
DAEMON="/opt/yace_cloudwatch_exporter/$PROGNAME"
#PORTNUM=""
CFGFILE="-config.file /etc/prometheus/yace_cloudwatch_exporter.yml"
LOGFILE=/var/log/yace_cloudwatch_exporter.log

[ -x $DAEMON ] || exit 0

# Need comes from yace cloudwatch due to new configured metrics
ulimit -n 2048

PID=$(ps -e -o ppid,pid,cmd|awk '$1==1 && /'$(echo $DAEMON|tr / .)'/ {print $2}')

start() {
    echo -n "Starting yace_cloudwatch_exporter: "
    if [ "x$PID" = "x" ]; then
	$DAEMON $PORTNUM $CFGFILE > $LOGFILE < /dev/null 2>&1 &
	RETVAL=$?
	echo "started"
	return $RETVAL
    else
	echo "yace_cloudwatch_exporter already running: $PID"
	return 2
    fi
}

stop() {
    echo -n "Stopping yace_cloudwatch_exporter: "
    if [ "x$PID" = "x" ]; then
	echo "yace_cloudwatch_exporter already stopped"
    else
	kill -TERM $PID
	kill -0 $PID
	echo "yace_cloudwatch_exporter stopped"
    fi
    return 0
}

status() {
    if [ "x$PID" = "x" ]; then
	echo "yace_cloudwatch_exporter not running"
    else
	echo "yace_cloudwatch_exporter running at $PID"
    fi
    return 0
}

reload() {
    echo -n "Reloading yace_cloudwatch_exporter: "
    if [ "x$PID" = "x" ]; then
	echo "yace_cloudwatch_exporter not running"
    else
	kill -HUP $PID
	echo "yace_cloudwatch_exporter reloaded"
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
    *)
	echo "Usage: $0 {start|stop|status|restart}"
	exit 1
	;;
esac
exit $?

