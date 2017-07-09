#!/bin/bash

# IPs or hostnames to check if none provided as arguments to the script
hosts='
example.com
example.net
example.org
192.0.43.10
'

# Locally maintained list of DNSBLs to check
LocalList='
b.barracudacentral.org
'

# pipe delimited exclude list for remote lists
Exclude='^dnsbl.mailer.mobi$|^foo.bar$|^bar.baz$'

# Remotely maintained list of DNSBLs to check
WPurl="https://en.wikipedia.org/wiki/Comparison_of_DNS_blacklists"
WPlst=$(curl -s $WPurl | egrep "([a-z]+\.){1,7}[a-z]+" | sed -r 's|||g;/$Exclude/d')


# ---------------------------------------------------------------------

HostToIP()
{
 if ( echo "$host" | egrep -q "[a-zA-Z]" ); then
   IP=$(host "$host" | awk '/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/ {print$NF}')
 else
   IP="$host"
 fi
}

Repeat()
{
 printf "%${2}s\n" | sed "s/ /${1}/g"
}

Reverse()
{
 echo $1 | awk -F. '{print$4"."$3"."$2"."$1}'
}

Check()
{
 result=$(dig +short $rIP.$BL)
 if [ -n "$result" ]; then
   echo -e "MAY BE LISTED \t $BL (answer = $result)"
 else
   echo -e "NOT LISTED \t $BL"
 fi
}

if [ -n "$1" ]; then
  hosts=$@
fi

if [ -z "$hosts" ]; then
  hosts=$(netstat -tn | awk '$4 ~ /[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/ && $4 !~ /127.0.0/ {gsub(/:[0-9]+/,"",$4);} END{print$4}')
fi

for host in $hosts; do
  HostToIP
  rIP=$(Reverse $IP)
  # remote list
  echo; Repeat - 100
  echo " checking $IP against BLs from $WPurl"
  Repeat - 100
  for BL in $WPlst; do
    Check
  done
  # local list
  echo; Repeat - 100
  echo " checking $IP against BLs from a local list"
  Repeat - 100
  for BL in $LocalList; do
    Check
  done
done
