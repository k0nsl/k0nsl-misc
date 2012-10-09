#!/bin/bash
#
# Commandline script to reformat and display "nginx_status" (see 
# http://wiki.nginx.org/HttpStubStatusModule).
# Created by D. Robbins.
# Last revised: 14 Apr 2011.
# Free for everyone.
#
# SETTINGS --------------------------------------------------------------------
#
PIDFILE="/var/run/nginx.pid"
STATUS="http://127.0.0.1/nginx_status"
#
# END SETTINGS ----------------------------------------------------------------
#
NOW=`date +%s`
NGINX_START=`stat -c %Y $PIDFILE`
if [ -z "$NGINX_START" ]; then
	echo "Can't find nginx's pid file."
	exit 1
fi
STAT=`curl -s $STATUS`
OLDIFS="$IFS"
IFS=$'\n'
STAT=($STAT)
if [[ ! "${STAT[0]}" =~ "Active connections" ]]; then
	echo "Failed to curl status URL: $STATUS"
	exit 1
fi
IFS=$' '
SUMM=(${STAT[2]})
REQUESTS=${SUMM[2]}
CON_ACCEPTED=${SUMM[0]}
CON_HANDLED=${SUMM[1]}
IFS="$OLDIFS"
ACTIVE=${STAT[0]}
CURRENT=${STAT[3]}
DURATION=$((NOW - $NGINX_START))
if [ "$DURATION" -gt "86399" ]; then
	UPTIME="`echo $DURATION | awk '{ printf("%.1f", $1 / 86400) }'` days"
elif [ "$DURATION" -gt "3599" ]; then
	UPTIME="`echo $DURATION | awk '{ printf("%.1f", $1 / 3600) }'` hours"
else
	UPTIME="`echo $DURATION | awk '{ printf("%.0f", $1 / 60) }'` minutes"
fi
REQPERCON=`echo $REQUESTS $CON_HANDLED | awk '{ printf("%.1f", $1 / $2) }'`
REQPERSEC=`echo $REQUESTS $DURATION | awk '{ printf("%.1f", $1 / $2) }'`
# Pad strings
PLEN=%$((${#REQUESTS}))s
CON_ACCEPTED=`printf "$PLEN" $CON_ACCEPTED`
CON_HANDLED=`printf "$PLEN" $CON_HANDLED`
echo "
Nginx up $UPTIME

$ACTIVE
$CURRENT

Connections Accepted: $CON_ACCEPTED
 Connections Handled: $CON_HANDLED
      Total Requests: $REQUESTS

 Requests/Connection: $REQPERCON
     Requests/Second: $REQPERSEC
"
exit 0