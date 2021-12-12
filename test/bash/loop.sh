#!/bin/env bash

for planet in "Mercury 36" "Venus 67" "Earth 93" "Mars 142" "Jupiter 483"
do
	set -- $planet # parse var, use position var to reference it 
	echo "$1        $2,000,000 miles from the sun"
done


generate_list()
{
	echo "one two three"
	echo "four five six"
}

for word in $(generate_list)
do
	echo $word
done

LIMIT=10
((a=1))
while ((a <= LIMIT))
do
	echo -n "$a "
	((a++))
done
exit 0
