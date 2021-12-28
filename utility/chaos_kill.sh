#!/bin/env bash
#set -x
source ./common.sh

interval=1000
self=$0

cnt=`ps -ef|grep $self|grep -v grep|wc -l`
if [ $cnt -gt 2 ]; then  #bash and script will contribute a process seperately
	echo "chaoskill exsits"
	exit 1
fi

count=1
while true :
do
	sleep $interval
	psql t500 -f chaos.sql
	echo `date`":$count process segv injection on all segment servers: ">>$OUTDIR/$runtimelog
	count=$((count+1))
done

killtest(){
	find=`ps -ef|grep $testcmd|grep -v grep`
	if [ $? == 0 ];then
		ps -ef|grep $testcmd |grep -v grep|awk '{print "kill -9 "$2}'|sh
	fi
}

