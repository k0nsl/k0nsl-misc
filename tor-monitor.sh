#!/bin/bash
if /bin/ps aux  | grep /usr/bin/tor >/dev/null
  then
    echo "Tor is running. Exiting."
    exit 0
  else
    echo "Tor is not running. Reloading daemon(s)."
    service tor restart
    exit 1
fi
