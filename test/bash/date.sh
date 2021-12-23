#!/bin/env bash
#time diff, unit:sec
start=`date +%s`
sleep 5
end=`date +%s`
echo "run time is "$((end-start))"sec"

#time to sec
time1=$(date +%s -d '1990-01-01 01:01:01')
echo "secs of 1990-01-01 01:01:01 is $time1"

# date addition
time1=$(($time1+$time2))
time1=$(date +%Y-%m-%d\ %H:%M:%S -d "1970-01-01 UTC $time1 seconds");

echo $time1

# like a=`date`
a=$(date)

# like a=`expr 1 + 2`
a=$((1+2))
