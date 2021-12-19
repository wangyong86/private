#!/bin/env bash
for bg in {40..47}
do
	for font in {30..37}
	do
		echo -e "\033[${bg};${font}mHelloworld\033[0m"
	done
	echo
done
