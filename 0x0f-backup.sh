#!/usr/bin/env bash
zip -q -r 0x0f-$( date '+%Y-%m-%d_%H-%M' ).zip /home/0x0f.su && /root/0x0f-tools/dropbox_uploader.sh -q upload /root/0x0f-tools/0x0f-$( date '+%Y-%m-%d_%H-%M' ).zip 0x0f
rm -rf /root/0x0f-tools/0x0f-*.zip
