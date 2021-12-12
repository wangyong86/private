#!/bin/env bash
E_NO_ARGS=65

if [ $# -eq 0 ]
then
	echo "input arguments"
	exit $E_NO_ARGS
fi

var01=abcdEFGH28ij
echo "var01 = ${var01}"
echo "length of var01 = ${#var01}"

var02="abcd EFGH28ij"
echo "length of var02 = ${#var02}"

echo "Number of command-line arguments passed to script= ${#@}"
echo "Number of command-line arguments passed to script= ${#*}"

exit 0
