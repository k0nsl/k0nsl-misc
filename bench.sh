#!/usr/bin/env bash

#################################################################################################
##                                                                                             ##
## A rudimentary ‘no bullshit’ benchmark tool primarily geared toward Debian-based distros.    ##
##  _                     _           _                                                        ##
## | |__   ___ _ __   ___| |__    ___| |__                                                     ##
## | '_ \ / _ \ '_ \ / __| '_ \  / __| '_ \                                                    ##
## | |_) |  __/ | | | (__| | | |_\__ \ | | |                                                   ##
## |_.__/ \___|_| |_|\___|_| |_(_)___/_| |_|                                                   ##
##                                                                                             ##
## Official site: http://bench.mirror.k0nsl.org                                                ##
#################################################################################################

# User permission check (credit: Tor2web)
if [ ! $(id -u) = 0 ]; then
  echo "Error: bench.sh must be run with elevated privileges."
  exit 1
fi

exists()
{
  command -v "$1" >/dev/null 2>&1
}

# Installation of bc
if exists bc; then
    echo 'bc detected.' >/dev/null 2>&1
else
 apt-get -qq -y install bc >/dev/null 2>&1
 echo 'bc not detected; installing.' >/dev/null 2>&1
fi

# Temporarily disable csf/lfd
if exists csf; then
    csf -x >/dev/null 2>&1
else
 echo 'csf/lfd not detected' >/dev/null 2>&1
fi

# System information
cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
tram=$( free -m | awk 'NR==2 {print $2}' )
swap=$( free -m | awk 'NR==4 {print $2}' )
up=$( uptime | awk -F'( |,|:)+' '{if ($7=="min") m=$6; else {if ($7~/^day/) {d=$6;h=$8;m=$9} else {h=$6;m=$7}}} {print d+0,"days,",h+0,"hours,",m+0,"minutes"}')
kernel=$(uname -r)

# Welcome text
echo ""
echo ""
echo ""
echo -e "\033[31m\E[1mColormedia Benchmark 0.1/a (forked by k0nsl)\033[0m"
echo -e "\033[32mWebsite  : k0nsl.org\033[0m"
echo -e "\033[32mContact  : irc.k0nsl.org #k0nsl\033[0m"

# General information
echo ""
echo -e "\033[37mGeneral Information \033[0m"
echo ""

echo -e "\033[35mCPU :\033[0m \033[36m$cname\033[0m"
echo -e "\033[35mCPU Cores :\033[0m  \033[36m$cores\033[0m"
echo -e "\033[35mCPU frequency per core :\033[0m \033[36m$freq MHz\033[0m"
echo -e "\033[35mMemory :\033[0m \033[36m$tram MB\033[0m"
echo -e "\033[35mSwap Space :\033[0m \033[36m$swap MB\033[0m"
echo -e "\033[35mUptime :\033[0m \033[36m$up\033[0m"
echo -e "\033[35mKernel :\033[0m \033[36m$kernel\033[0m"

# Network Benchmark
echo ""
echo -e "\033[37mNetwork Benchmark \033[0m"
echo ""

curl -o /dev/null debian.org -sm3
if [[ $? != 0 ]]; then
	echo -e "\e[35mfailed\e[0m"
	exit 1
else

#BuyVM #1: https://my.frantech.ca/aff.php?aff=781
buyvm01=$( wget -O /dev/null https://speedtest.ny.buyvm.net/100MB.test 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo -e "\033[35mDownload Speed:\033[0m \033[36m BuyVM (US):\033[0m $buyvm01 "
buyvm01=${buyvm01:0:$((${#buyvm01})) - 4}

#DigitalOcean #1: https://www.digitalocean.com/?refcode=85b929177e54
do01=$( wget -O /dev/null http://speedtest-sfo3.digitalocean.com/100mb.test 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo -e "\033[35mDownload Speed:\033[0m \033[36m DigitalOcean (US):\033[0m $do01 "

#RamNode #1: https://clientarea.ramnode.com/aff.php?aff=1058
rn01=$( wget -O /dev/null http://lg.atl.ramnode.com/static/100MB.test 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo -e "\033[35mDownload Speed:\033[0m \033[36m RamNode (US):\033[0m $rn01 "

#Incero mirror: http://mirror.incero.com/
incero01=$( wget -O /dev/null http://mirror.incero.com/100mb.test 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo -e "\033[35mDownload Speed:\033[0m \033[36m Incero (US):\033[0m $incero01 "

#Dacentec: https://billing.dacentec.com/hostbill/?affid=88
dacentec=$( wget -O /dev/null http://mirror.dacentec.com/100MB.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo -e "\033[35mDownload Speed:\033[0m \033[36m Dacentec (USA):\033[0m $dacentec "

#HostHatch: https://portal.hosthatch.com/aff.php?aff=173
hosthatch=$( wget -O /dev/null http://lg.sto.hosthatch.com/100MB.test 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo -e "\033[35mDownload Speed:\033[0m \033[36m HostHatch (EU):\033[0m $hosthatch "

#DigitalOcean #2: https://www.digitalocean.com/?refcode=85b929177e54
do02=$( wget -O /dev/null http://speedtest-ams2.digitalocean.com/100mb.test 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo -e "\033[35mDownload Speed:\033[0m \033[36m DigitalOcean (EU):\033[0m $do02 "

#RamNode #2: https://clientarea.ramnode.com/aff.php?aff=1058
rn02=$( wget -O /dev/null http://lg.nl.ramnode.com/static/100MB.test 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo -e "\033[35mDownload Speed:\033[0m \033[36m RamNode (EU):\033[0m $rn02 "

#BuyVM #3: https://my.frantech.ca/aff.php?aff=781
buyvm03=$( wget -O /dev/null http://speedtest.lu.buyvm.net/100MB.test 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo -e "\033[35mDownload Speed:\033[0m \033[36m BuyVM (EU):\033[0m $buyvm03 "

#YourServer: https://www.yourserver.se/portal/aff.php?aff=081
yourserver=$( wget -O /dev/null https://lv.lg.yourserver.se/100MB.test 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo -e "\033[35mDownload Speed:\033[0m \033[36m YourServer (EU):\033[0m $yourserver "
fi

# HDD/SSD Benchmark
echo ""
echo -e "\033[37mDisk Benchmark\033[0m"
echo ""

io=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -Fs, '{io=$NF} END { print io}' )
echo "I/O Performance [1]: $io"
io=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -Fs, '{io=$NF} END { print io}' )
echo "I/O Performance [2]: $io"
io=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -Fs, '{io=$NF} END { print io}' )
echo "I/O Performance [3]: $io"

# CPU Benchmark
echo ""
echo -e "\033[37mCPU Benchmark\033[0m"
time echo "scale=4000; a(1)*4" | erg=$(bc -l)
echo ""
echo ""

# Re-enable csf/lfd
if exists csf; then
    csf -e >/dev/null 2>&1
else
 echo 'csf/lfd not detected' >/dev/null 2>&1
fi
