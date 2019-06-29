#!/bin/sh
# ./TrafficCheck.sh port
# ./TrafficCheck.sh 80
# ./TrafficCheck.sh port check limit(MiB)
# ./TrafficCheck.sh 80   yes   10

if [ ! -n "$1" ] ;
then
    echo "port number is a MUST!"
    exit 1
fi

#clear

RED='\033[0;31m' # Red Color
BLUE='\033[0;34m' # Blue Color
NC='\033[0m' # No Color

BOLD=$(tput bold)
NORMAL=$(tput sgr0)

UDPIN="$(iptables -t filter -vxnL | grep "udp dpt:$1" | grep -v "DROP" | awk '{printf("%.3f\n",$2/(1000*1000))}')"
UDPOUT="$(iptables -t filter -vxnL | grep "udp spt:$1" | grep -v "DROP" | awk '{printf("%.3f\n",$2/(1000*1000))}')"
TCPIN="$(iptables -t filter -vxnL | grep "tcp dpt:$1" | grep -v "DROP" | awk '{printf("%.3f\n",$2/(1000*1000))}')"
TCPOUT="$(iptables -t filter -vxnL | grep "tcp spt:$1" | grep -v "DROP" | awk '{printf("%.3f\n",$2/(1000*1000))}')"

TCP=$(echo "$TCPIN + $TCPOUT" | bc -l)
UDP=$(echo "$UDPIN + $UDPOUT" | bc -l)
BOTH=$(echo "$TCP + $UDP" | bc -l)

echo 'PORT: '$1
echo '======================'
echo 'TCP In: '$TCPIN' MiB'
echo 'TCP Out: '$TCPOUT' MiB'
echo 'UDP In: '$UDPIN' MiB'
echo 'UDP Out: '$UDPOUT' MiB'
echo '======================'
echo 'TCP Total: '$TCP' MiB'
echo 'UDP Total: '$UDP' MiB'
echo 'BOTH Total: '$BOTH' MiB'
echo '======================'

if [ "$2" = "" ]
then
    echo "exit."
    exit 0
else
    if [ "$3" = "" ]
    then
        echo "TRAFFIC LIMIT(MiB) IS A MUST!"
        exit 1
    else
        echo "Traffic limit is $3 MiB"
        if [ `echo "$3 > $BOTH" | bc` -eq 1 ]
        then
            echo "$BLUE$BOLD It's OK $NORMAL$NC"
			echo "clean rules"
            iptables -D INPUT -p tcp --dport $1 -j DROP
            iptables -D INPUT -p udp --dport $1 -j DROP
            exit 0
        else
            echo "$RED$BOLD Bandwidth limit exceeded,STOP IT $NORMAL$NC"
            echo "clean rules"
            iptables -D INPUT -p tcp --dport $1 -j DROP
            iptables -D INPUT -p udp --dport $1 -j DROP
            echo "add rules"
            iptables -I INPUT -p tcp --dport $1 -j DROP
            iptables -I INPUT -p udp --dport $1 -j DROP
            exit 0
        fi
    fi
fi
