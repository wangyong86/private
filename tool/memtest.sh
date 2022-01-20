#!/bin/bash
times=10 #as default value
elmts=100000000 # as default value
bin=stream
output=membw.rst

if [ $# != 0 ]; then
	output=$1
fi

sudo dmidecode -t 3 -t 7 -t 17 >$output

execonce(){
	param=""
	if [ $1 != 0 ]; then
		param="-DOMP_NUM_THREADS="$1" -fopenmp"
	fi

	param=$param" -DSTREAM_TYPE="$2
	param=$param" -DNTIMES="$3
	param=$param" -DSTREAM_ARRAY_SIZE="$4
	echo "Round: $5, "$param >> $output
	gcc -O $param stream.c -o $bin
	./$bin >> $output
}
for type in int float double
do
	for thdnum in 0 1  #0: non-omp 1: 64thread
	do
		for round in 1 2
		do
			execonce $thdnum $type $times $elmts $round
		done
	done
done
