#!/bin/bash

# ZRAM config for Raspberry Pi 3 by sultanqasim (sultanqasim@gmail.com)
# Tuned for quad core, 1 GB RAM models
# put me in /etc/init.d/rpi3-zram.sh and make me executable
# then run "sudo update-rc.d rpi3-zram.sh defaults"

modprobe zram
echo 3 >/sys/devices/virtual/block/zram0/max_comp_streams
echo lz4 >/sys/devices/virtual/block/zram0/comp_algorithm
echo 268435456 >/sys/devices/virtual/block/zram0/mem_limit
echo 536870912 >/sys/devices/virtual/block/zram0/disksize
mkswap /dev/zram0
swapon -p 0 /dev/zram0
sysctl vm.swappiness=70
