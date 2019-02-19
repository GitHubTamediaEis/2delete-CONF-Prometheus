#!/bin/bash
#
# alertmanager    Start stop alertmanager
#
# chkconfig: 345 20 80
# description: Start, stop script for alertmanager
# processname: alertmanager

PROGNAME=alertmanager
DAEMON=/opt/alertmanager/$PROGNAME
CONFIG=/etc/prometheus/alertmanager.yml
LOGFILE=/var/log/alertmanager.log

[ -x $DAEMON ] || exit 0

PID=$(ps -e -o ppid,pid,cmd|awk '$1==1 && /'$(echo $DAEMON|tr / .)'/ {print $2}')

start() {
    echo -n "Starting alertmanager: "
    if [ "x$PID" = "x" ]; then
	    $DAEMON --config.file=$CONFIG > $LOGFILE < /dev/null 2>&1 &
	    RETVAL=$?
	    echo "started"
	    return $RETVAL
    else
	    echo "alertmanager already running: $PID"
	    exit 2
    fi
}

stop() {
    echo -n "Stopping alertmanager: "
    if [ "x$PID" = "x" ]; then
	    echo "alertmanager already stopped"
    else
	    kill -TERM $PID
	    kill 0 $PID
	    echo "alertmanager stopped"
    fi
    return 0
}

status() {
    if [ "x$PID" = "x" ]; then
	    echo "alertmanager not running"
    else
	    echo "alertmanager running at $PID"
    fi
    return 0
}

reload() {
    echo -n "Reloading alertmanager: "
    if [ "x$PID" = "x" ]; then
	    echo "alertmanager not running"
    else
	    kill -HUP $PID
	    echo "alertmanager reloaded"
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

