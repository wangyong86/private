#!/bin/env bash

if [ "x"$MASTER_DATADIR = "x" ]; then
    target=/home/wy
else
    target=$MASTER_DATADIR
fi

corepattern="core*[0-9]*"
#target=/home/wy/matrixdb

find $target -name "$corepattern" -exec ls -lh {} +
count=`find $target -name "$corepattern"|wc -l`
echo "$count corefiles found in dir $target"
if  [ $# == 1 ]; then
	if [ "$1" = "-c" ]; then
		find $target -name "$corepattern" -exec rm {} +
		echo "$count corefiles removed!!!"
	else
		echo "unexpect parameter:" $@
		echo "./pcore.sh [-c]" 
	fi
fi
