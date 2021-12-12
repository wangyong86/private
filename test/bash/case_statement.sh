#!/bin/env bash
SUCCESS=0
FAILURE=1

isalpha ()
{
	if [ -z "$1" ]
	then 
		return $FAILURE
	fi

	case "$1" in
		[a-zA-Z]*) return $SUCCESS;;
		*) return $FAILURE;;
	esac
}

isalpha2 ()
{
	[ $# -eq 1 ] || return $FAILURE

	case "$1" in
		[a-zA-Z]*) return $SUCCESS;;
		*) return $FAILURE;;
	esac
}

isdigit ()
{
	[ $# -eq 1 ] || return $FAILURE

	case $1 in
		*[!0-9]*|"") return $FAILURE;;
			*) return $SUCCESS;;
	esac
}

check_var()
{
	if isalpha "$@"
	then
		echo "\"$*\" begins with an alpha character."
		if isalpha2 "$@"
		then
			echo "\"$*\" contains only alpha character."
		else
			echo "\"$*\" contains at least one non-alpha character."
		fi
	else
		echo "\"$*\" begins with an non-alpha character."
	fi
}
