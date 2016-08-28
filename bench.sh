#!/bin/bash

#Mirror: https://k0nsl.org/blog/snippets/bench-cpu-sh/

#Installation von BC
apt-get install bc -y

#Infos über System
cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
tram=$( free -m | awk 'NR==2 {print $2}' )
swap=$( free -m | awk 'NR==4 {print $2}' )
up=$( uptime | awk -F'( |,|:)+' '{if ($7=="min") m=$6; else {if ($7~/^day/) {d=$6;h=$8;m=$9} else {h=$6;m=$7}}} {print d+0,"days,",h+0,"hours,",m+0,"minutes"}')
kernel=$(uname -r)

#Willkommens-Text
echo ""
echo ""
echo ""
echo -e "\033[31m\E[1mColormedia Benchmark 0.1/a (forked by k0nsl)\033[0m"
echo -e "\033[32mWebsite  : k0nsl.org\033[0m"
echo -e "\033[32mContact  : irc.k0nsl.org #k0nsl\033[0m"

#Allgemeine Informationen
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

#Netzwerk Benchmark
echo ""
echo -e "\033[37mNetwork Benchmark \033[0m"
echo ""

#BuyVM #1: https://my.frantech.ca/aff.php?aff=781
buyvm01=$( wget -O /dev/null http://speedtest.nj.buyvm.net/100MB.test 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo -e "\033[35mDownload Speed:\033[0m \033[36m BuyVM (US):\033[0m $buyvm01 "
buyvm01=${buyvm01:0:$((${#buyvm01})) - 4}

#DO: https://www.digitalocean.com/?refcode=85b929177e54
do=$( wget -O /dev/null http://speedtest-sfo1.digitalocean.com/100mb.test 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo -e "\033[35mDownload Speed:\033[0m \033[36m DigitalOcean (US):\033[0m $do "

#RamNode: https://clientarea.ramnode.com/aff.php?aff=1058
ramnode=$( wget -O /dev/null http://lg.la.ramnode.com/static/100MB.test 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo -e "\033[35mDownload Speed:\033[0m \033[36m RamNode (US):\033[0m $ramnode "

#BuyVM #2: https://my.frantech.ca/aff.php?aff=781
buyvm02=$( wget -O /dev/null http://speedtest.lu.buyvm.net/100MB.test 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo -e "\033[35mDownload Speed:\033[0m \033[36m BuyVM (EU):\033[0m $buyvm02 "

#HostHatch: https://portal.hosthatch.com/aff.php?aff=173
hosthatch=$( wget -O /dev/null http://mirror.lax.hosthatch.com/100mb.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo -e "\033[35mDownload Speed:\033[0m \033[36m HostHatch (USA):\033[0m $hosthatch "

#HDD Benchmark
echo ""
echo -e "\033[37mDisk Benchmark\033[0m"
echo ""

io=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -Fs, '{io=$NF} END { print io}' )
echo "I/O Performance [1]: $io"
io=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -Fs, '{io=$NF} END { print io}' )
echo "I/O Performance [2]: $io"
io=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -Fs, '{io=$NF} END { print io}' )
echo "I/O Performance [3]: $io"

#CPU Benchmark
echo ""
echo -e "\033[37mCPU Benchmark\033[0m"
time echo "scale=4000; a(1)*4" | erg=$(bc -l)
echo ""
echo ""
