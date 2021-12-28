#!/bin/env bash

#democluster location
target=/home/wy/matrixdb

find $target -name "core*" -exec ls -lh {} +
count=`find $target -name "core.*"|wc -l`
echo "$count corefiles found in dir $target"
if  [ $# == 1 ]; then
	if [ "$1" = "-c" ]; then
		find $target -name "core*" -exec rm {} +
		echo "$count corefiles removed!!!"
	else
		echo "unexpect parameter:" $@
		echo "./pcore.sh [-c]" 
	fi
fi
