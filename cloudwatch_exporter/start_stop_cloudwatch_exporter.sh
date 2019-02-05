#!/bin/bash
#
# cloudwatch_exporter    Start stop cloudwatch_exporter
#
# chkconfig: 345 20 80
# description: Start, stop script for cloudwatch_exporter
# processname: cloudwatch_exporter

PROGNAME=cloudwatch_exporter
JAR=/opt/cloudwatch_exporter/$PROGNAME-jar-with-dependencies.jar
LOGFILE=/var/log/cloudwatch_exporter.log
CONFIG=/etc/prometheus/cloudwatch_exporter.yaml

[ -f $JAR ] || exit 0

PID=$(ps -e -o ppid,pid,cmd|awk '$1==1 && /'$(echo $JAR|tr / .)'/ {print $2}')

start() {
    echo -n "Starting Cloudwatch_Exporter: "
    if [ "x$PID" = "x" ]; then
	java -jar $JAR 9106 $CONFIG > $LOGFILE < /dev/null 2>&1 &
	RETVAL=$?
	echo "started"
	return $RETVAL
    else
	echo "cloudwatch_exporter already running: $PID"
	exit 2
    fi
}

stop() {
    echo -n "Stopping Cloudwatch_Exporter: "
    if [ "x$PID" = "x" ]; then
	echo "cloudwatch_exporter already stopped"
    else
	kill -TERM $PID
	kill 0 $PID
	echo "cloudwatch_exporter stopped"
    fi
    return 0
}

status() {
    if [ "x$PID" = "x" ]; then
	echo "cloudwatch_exporter not running"
    else
	echo "cloudwatch_exporter running at $PID"
    fi
    return 0
}

reload() {
    echo -n "Reloading Cloudwatch_Exporter: "
    if [ "x$PID" = "x" ]; then
	echo "cloudwatch_exporter not running"
    else
	kill -HUP $PID
	echo "cloudwatch_exporter reloaded"
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

