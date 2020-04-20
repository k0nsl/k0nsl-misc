#!/bin/bash

#########################################################################
#                      SSH GeoLite2 SSH Filtering                       #
#                      Written by Ralph Slooten                         #
#                                                                       #
# INSTALLATION: edit "/etc/hosts.alow" and comment out "sshd: ALL"      #
#               replace it with the following line:                     #
#               sshd: ALL: aclexec /usr/local/bin/sshfilter.sh %a       #
#                                                                       #
#########################################################################

# UPPERCASE space-separated country codes to ACCEPT
ALLOW_COUNTRIES="SE,DK"

if [ $# -ne 1 ]; then
  echo "Usage:  `basename $0` <ip>" 1>&2
  exit 0 # return true in case of config issue
fi

COUNTRY=`/usr/bin/geoiplookup $1 | awk -F ": " '{ print $2 }' | awk -F "," '{ print $1 }' | head -n 1`

[[ $COUNTRY = "IP Address not found" || $ALLOW_COUNTRIES =~ $COUNTRY ]] && RESPONSE="ALLOW" || RESPONSE="DENY"

if [ $RESPONSE = "ALLOW" ]
then
  exit 0
else
  logger "$RESPONSE sshd connection from $1 ($COUNTRY)"
  exit 1
fi
