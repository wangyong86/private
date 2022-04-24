#!/bin/bash
numerictype=1
if [ "$numerictype" == 1 ]; then
	echo "numerictype can be compare with numeric value"
fi

if [ $numerictype -eq 1 ]; then
	echo "numerictype can be compare with numeric value correctly"
fi

if [ $numerictype -eq 2 ]; then
	echo "numerictype can't be compare with numeric value correctly"
fi
