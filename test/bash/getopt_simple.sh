#!/bin/env bash

getopt_simple()
{
	echo "getopt_simple()"
	echo "Parameters are '$*'"
	until [ -z "$1" ]
	do
		echo "Processing parameter of: '$1'"
		if [ ${1:0:1} = '/' ]
		then
			tmp=${1:1}
			parameter=${tmp%%=*}
			value=${tmp##*=}
			echo "Parameter: '$parameter', value: '$value'"
			eval $parameter=$value
		fi
		shift
	done
}

getopt_simple $*

echo "test is '$test'"
echo "test2 is '$test2'"

exit 0
