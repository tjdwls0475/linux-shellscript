#!/bin/bash

OS=`uname -s`
OSVER=`uname -r`
WHOAMI=`id|cut -d"(" -f2|cut -d")" -f1`

# Check if current user has root privileges
function CHECK_PRIV {
	PRIV=$WHOAMI
	if [ ! "$PRIV" = "root" ]; then
		echo "You must have root privilege."
		exit 1
	fi
}

# Delete logs older than 30 days
function SWEEP_WEB_LOG {
	/usr/bin/find /var/log/httpd/ -mtime +30 -type f -exec rm {} \; 2> /dev/null
}

# Delete logs older than 30 days with rsyslog daemon
function SWEEP_LOG_WITH_RSYSLOG {
	/usr/bin/find /var/log/httpd/ -mtime +30 -type f -exec rm {} \; 2> /dev/null
	RSYSLOG_PID=`ps -e | grep rsyslogd | awk '{print $1}'`
	kill -HUP $RSYSLOG_PID 2> /dev/null
}

CHECK_PRIV
SWEEP_WEB_LOG
