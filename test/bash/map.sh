#!/bin/env bash

declare -A a
a['1']='world'
a['2']='america'
a[2]='russia'
a[0.2]='nieria'

echo ${a['1']} # world
echo ${a[2]} # russia
echo ${a[0.2]} # russia
echo ${a[10]}

# refer key
for key in ${!a[*]};do
	echo $key, ${a[$key]}
done

# refer key
for value in ${a[@]};do
	echo $value
done

#all keys and values
echo "all keys: " ${!a[@]}

echo "all values: "${a[@]}
echo "length: "${#a[@]} #length

if [ x"${a[10]}" == x ]; then
	echo non-exist
fi
