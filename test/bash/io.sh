#!/bin/env bash

num=$((RANDOM%100+1)) # $((expr))
while :
do
	read -p " we generate a number between 0 and 100, please guess it:" n
	if [ $n -eq 0 ]; then
		echo "value is:$num"
	fi

	if [ $n -gt $num ]; then
		echo "larger, continue"
	elif [ $n -lt $num ]; then
		echo "smaller, continue"
	else
		echo "congratulations!, value is:$num"
		break
	fi
done

file=io.sh
while read line
do
	echo $line
done < "$file"
