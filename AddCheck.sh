#!/bin/sh
# AddCheck.sh port
if [ ! -n "$1" ] ;
then
    echo "port number is a MUST!"
    exit 1
fi

iptables -I INPUT -p tcp --dport $1
iptables -I INPUT -p udp --dport $1
iptables -I OUTPUT -p tcp --sport $1
iptables -I OUTPUT -p udp --sport $1
