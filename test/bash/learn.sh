#!/bin/bash

# Select postgres processes with some keywords
if [[ $1 = "" ]]; then
	pgs=`ps -ef | grep postgres`
	pids=$(ps -ef | grep postgres | awk '{print $2}')
else
	pgs=`ps -ef | grep postgres | grep $1`
	pids=$(ps -ef | grep postgres | grep $1 | awk '{print $2}')
fi

if [[ $pids = "" ]]; then
	echo "Process not found"
	exit
fi

# Print postgres processes
printf '%s\n' "$pgs"

select pid in ${pids[@]}; do
	if [[ $pid = "" ]]; then
		echo "Process not found"
		exit
	fi
	lldb -p $pid
    break
done
