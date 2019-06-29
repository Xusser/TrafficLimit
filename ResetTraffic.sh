#!/bin/sh
# ResetTraffic.sh port
if [ ! -n "$1" ] ;
then
    echo "port number is a MUST!"
    exit 1
fi

work_path=$(dirname $(readlink -f $0))

echo "WORK PATH is $work_path"
$work_path/DelCheck.sh $1
$work_path/AddCheck.sh $1
echo "Reset counter done"
exit 0
