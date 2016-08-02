#!/bin/bash
if curl -s --head https://k0nsl.org/ | grep "200 OK" >/dev/null
  then
    echo "The HTTPd returned a 200 OK." >/dev/null
    exit 0
  else
    echo "The HTTPd isn't returning a healthy reply." >/dev/null
    service nginx restart
    service php5-fpm restart
    exit 1
fi
