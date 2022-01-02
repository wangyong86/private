#!/bin/env bash
# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
    echo "** Trapped CTRL-C"
	exit 1
}

for i in `seq 1 5`; do
    sleep 1
    echo -n "."
done
