#!/bin/env bash

E_BADARGS=85

if [ -z "$1" ]
then
	echo "Usage: `basename $0` filename"
	exit $E_BADARGS
fi

TARGETFILE=$1

vi $TARGETFILE << x3234
i
This is line 1 of the example file.
This is line 1 of the example file.
This is line 1 of the example file.
^[
ZZ
x3234

ORIGINAL=smith
REPLACEMENT=Jones

for word in $(fgrep -l $ORIGINAL *.txt)
do
	ex $word <<EOF
	:%s/$ORIGINAL/$REPLACEMENT/g
	:wq
EOF
done

# output message block using cat

cat <<END-of-message
-----------------------------------------------
This is line 1 of the example file.
This is line 1 of the example file.
This is line 1 of the example file.
-----------------------------------------------
END-of-message

#NEWfile=log
#cat >$NEWfile <<END-of-message
exit
