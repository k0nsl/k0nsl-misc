#!/usr/bin/env zsh

## Clean up any stale tempfile
[[ -f /tmp/hosts.working ]] && rm -f /tmp/hosts.working

## Awk regex to be inverse-matched as whitelist
whitelist='/(k0nsl.org|goy.su)/'

## URLs of Ad Blacklists to Use
blacklist=('https://winhelp2002.mvps.org/hosts.txt' \
           'http://pgl.yoyo.org/as/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext' \
           'https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts' \
           'https://adaway.org/hosts.txt')

## Fetch all Blacklist Files
for url in $blacklist; do
    curl --silent -A "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.82 Safari/537.36" $url >> "/tmp/hosts.working"
done

## Process Blacklist, Eliminiating Duplicates, Integrating Whitelist, and Converting to unbound format
awk -v whitelist="$whitelist" '$1 ~ /^127\.|^0\./ && $2 !~ whitelist {gsub("\r",""); print tolower($2)}' /tmp/hosts.working | sort | uniq | \
awk '{printf "local-zone: \"%s\" redirect\n", $1; printf "local-data: \"%s. A 0.0.0.0\"\n", $1}' > /home/unbound/unbound-compiled/etc/unbound/conf/automated-blocklist.conf

# "Restart" unbound ;-)
killall unbound
/home/unbound/unbound-compiled/sbin/unbound -c /home/unbound/unbound-compiled/etc/unbound/unbound.conf

# Clean up tempfile
rm -f '/tmp/hosts.working'
