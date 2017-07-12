#!/bin/env bash
if /usr/bin/torify /usr/bin/curl -s --head http://vid2x7jyypqblcc4.onion/ | /bin/grep "200 OK" >/dev/null
  then
    /bin/echo "The HTTPd returned a 200 OK." >/dev/null
    exit 0
  else
    /bin/echo "The HTTPd isn't returning a healthy reply." >/dev/null
    echo "The tor-wrapper for Goy.Chat is currently unavailable." | swaks --to postmaster@k0nsl.org --from "alerts@k0nsl.org" --server mail.domain.tld --auth LOGIN --auth-user "redacted@domain.tld" --auth-password "redacted" -tls
    exit 1
fi
