#!/bin/env bash

clean=false
target=/home/wy
#target=/home/wy/matrixdb
corepattern="core.[0-9]*"
if [ "x"$MASTER_DATADIR = "x" ]; then
    target=$MASTER_DATADIR
fi

function help() {
	echo "./pcore.sh [-d \$dir_tobe_examined] [-c]"	
	exit
}

function parse_parameter {
	while [ "$#" -gt 0 ]; do
		if [ "$1" == "-d" ]; then
			shift
			if [ "$#" -eq 0 ]; then
				echo "-d must followed by target dir"
				help
			else
				target=$1
				shift
			fi
		elif [ "$1" == "-c" ]; then
			clean=true
			shift
		elif [ "$1" == "-h" ]; then
			help
		else
			echo "parameter must preceded by -c/-d/-h"
			help
			break
		fi
	done
}

print_parameter() {
	echo "dir:"$target" cleanup:"$clean
}

parse_parameter "$@"
print_parameter 

find $target -name "$corepattern" -exec ls -lh {} +
count=`find $target -name "$corepattern"|wc -l`
echo "$count corefiles found in dir $target"

if  [ $clean == "true" ]; then
	find $target -name "$corepattern" -exec rm {} +
	echo "$count corefiles removed!!!"
fi
