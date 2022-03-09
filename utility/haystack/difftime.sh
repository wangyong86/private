#!/bin/bash
#compare the differentiate set from pid in file b relateive pids in file a

#sample:
#2022-01-05 10:22:15.355309 CST,,,p146657,th398203072,,,,0,con22488,,seg89,,,,,"DEBUG","00000","InitPostgres",,,,,,,0,,"postinit.c",675,
#2022-01-05 10:22:15.394751 CST,,,p146534,th398203072,,,,0,con22502,,seg89,,,,,"DEBUG","00000","SessionState_Acquire: pinCount: 3, activeProcessCount: 1",,,,,,,0,,"session_state.c",121,"Stack trace:

inputfile=$1
beginkw=InitPostgres
endkw=SessionState_Acquire
timecolsn=
resultfile=timediff.rst
grep $beginkw $inputfile|awk -F'[ :,]' '{printf("%f %s\n", $2*3600+$3*60+$4, $8)}' >begin.tmp

>$resultfile
while read line
do
	time=`echo $line|awk '{print $1}'`
	thread=`echo $line|awk '{print $2}'`
	grep $endkw $inputfile|grep $thread|awk -v t=$time -v th=$thread -F'[ :]' '{printf("%f %s\n", $2*3600+$3*60+$4-t, th)}' >>$resultfile
done <begin.tmp
