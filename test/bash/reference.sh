#!/bin/bash
. functions.sh
file1=$1
file2=$2
if [[ "$(du "$file1")" -gt "$(du "$file2")" ]]
then
	echo "$file1 is larger than $file2"
fi
