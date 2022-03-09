#!/bin/bash
#compare the differentiate set from pid in file b relateive pids in file a

rstfile=diffpid.rst
firstoccur=first.rst
if [ $# -lt 2 ]; then
	echo "Must have two files as parameter"
	echo "Help: ./diff $filea $fileb"
	echo "Output: $rstfile"
	exit 1
fi

filter(){
	grep postgres $1|grep -v strace| awk '{if ($3=1004 && $5 != "-") print $5}'|sort >$2
}
filter $1 s1.tmp
filter $2 s2.tmp
sort s2.tmp s1.tmp s1.tmp|uniq -u > $rstfile

if [ $# = 3 ]; then
>$firstoccur
for pid in `cat $rstfile`
do
	grep $pid $3|head -1 >>$firstoccur
done
fi
