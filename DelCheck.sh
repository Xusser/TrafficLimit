#!/bin/sh
# DelCheck.sh port
if [ ! -n "$1" ] ;
then
    echo "port number is a MUST!"
    exit 1
fi

iptables -D INPUT -p tcp --dport $1
iptables -D INPUT -p udp --dport $1
iptables -D OUTPUT -p tcp --sport $1
iptables -D OUTPUT -p udp --sport $1
