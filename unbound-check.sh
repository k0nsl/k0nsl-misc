#!/usr/bin/env bash

SERVER=91.239.100.100
PORT=53
</dev/tcp/$SERVER/$PORT
if [ "$?" -ne 0 ]; then
echo "Connection failed!" > /dev/null
  exit 1
else
  echo "Connection OK!" > /dev/null
  exit 0
fi
