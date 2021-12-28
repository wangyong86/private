#!/bin/env bash
echo -e >a.out
echo "begin: "`date`
loopnum=10
for((i=0;i<$loopnum;i++))
do
	./table385test >> a.out
done
echo "end: "`date`
