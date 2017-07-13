#!/bin/env bash
if /usr/bin/torify /usr/bin/curl -s --head http://vid2x7jyypqblcc4.onion/ | /bin/grep "200 OK" >/dev/null
  then
    /bin/echo "The HTTPd returned a 200 OK." >/dev/null
    /usr/bin/swaks -t to@domain.tld -f "from@domain.tld" --header "Subject: Goy.Chat [up]" --body "The tor-wrapper for Goy.Chat is available and healthy." --server mail.domain.tld --auth LOGIN --auth-user "user@domain.tld" --auth-password "redacted" -tls -p 587
    exit 0
  else
    /bin/echo "The HTTPd isn't returning a healthy reply." >/dev/null
    /usr/bin/swaks -t to@domain.tld -f "from@domain.tld" --header "Subject: Goy.Chat [down]" --body "The tor-wrapper for Goy.Chat is unavailable — investigate immediately." --server mail.domain.tld --auth LOGIN --auth-user "user@domain.tld" --auth-password "redacted" -tls -p 587
    /usr/bin/curl -s https://domain.tld/goychat-webhook.php
    exit 1
fi
