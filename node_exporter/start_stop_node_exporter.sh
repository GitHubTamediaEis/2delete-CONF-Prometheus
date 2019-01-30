#!/bin/bash
#
# node_exporter    Start stop node_exporter
#
# chkconfig: 345 20 80
# description: Start, stop script for node_exporter
# processname: node_exporter

PROGNAME=node_exporter
DAEMON=/opt/node_exporter/$PROGNAME
PORTNUM=--web.listen-address=":9100"
LOGFILE=/var/log/node_exporter.log

[ -x $DAEMON ] || exit 0

PID=$(ps -e -o ppid,pid,cmd|awk '$1==1 && /'$(echo $DAEMON|tr / .)'/ {print $2}')

start() {
    echo -n "Starting Node_Exporter: "
    if [ "x$PID" = "x" ]; then
	$DAEMON $PORTNUM > $LOGFILE < /dev/null 2>&1 &
	RETVAL=$?
	echo "started"
	return $RETVAL
    else
	echo "node_exporter already running: $PID"
	exit 2
    fi
}

stop() {
    echo -n "Stopping Node_Exporter: "
    if [ "x$PID" = "x" ]; then
	echo "node_exporter already stopped"
    else
	kill -TERM $PID
	kill 0 $PID
	echo "node_exporter stopped"
    fi
    return 0
}

status() {
    if [ "x$PID" = "x" ]; then
	echo "node_exporter not running"
    else
	echo "node_exporter running at $PID"
    fi
    return 0
}

reload() {
    echo -n "Reloading Node_Exporter: "
    if [ "x$PID" = "x" ]; then
	echo "node_exporter not running"
    else
	kill -HUP $PID
	echo "node_exporter reloaded"
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

