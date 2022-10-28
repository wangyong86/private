#!/bin/bash

#获取输入参数,如果输入参数不等于3个,给出提示并退出
if [ $# -ne 3 ]
then
  echo "Usage $0 {Number of cycles[1] client Number[2] Sqlfile[3]}"
exit 1;
fi

CYCLE_NUM=$1
CLIENT_NUM=$2
SQLFILE=$3
HOST=localhost
PORT=5432
USER=mxadmin
DBNAME=mxdb_poc
SQLFILE_DIR="./sql"

if  [ -f  "sqltime.log"  ]; then
rm  -f sqltime.log
fi

ls pgbench_log.* >/dev/null 2>&1
if [ $? -eq 0 ] ;then
  logfile=`ls pgbench_log.*`
  for a in ${logfile}
  do
    if  [ -f  ${a}  ]; then
    rm  -f ${a}
    fi
  done
fi

for ((i=1; i<=${CYCLE_NUM}; i++))
do
eval "pgbench -c ${CLIENT_NUM} -P 5 -n -f ${SQLFILE_DIR}/${SQLFILE} -h ${HOST} -p ${PORT} -U ${USER} ${DBNAME} --aggregate-interval=1 -l pgbench_log  -T 30" >/tmp/run.log 2>&1
grep "latency average" /tmp/run.log >>sqltime.log
cat pgbench_log.*|grep -v "0 0 0 0 0" >>sqltime.log
rm -f pgbench_log.*
done

#cat sqltime.log
echo '######################################################################'
echo '执行时间：'
#最大值
maxvalue=`cat sqltime.log |grep -v "latency average"|awk '{print $6}'|awk '$0>a{a=$0}END{print a}'`
echo "最大值:"`eval "awk 'BEGIN{printf \"%0.3f\",${maxvalue}/1000}'"` "ms"
#最小值
minvalue=`cat sqltime.log |grep -v "latency average"|awk '{print $5}'|sort -n| head -1`
echo "最小值:"`eval "awk 'BEGIN{printf \"%0.3f\",${minvalue}/1000}'"` "ms"
#平均值
echo "平均值:"`cat sqltime.log |grep "latency average"|awk '{a+=$4}END{print a/NR}'` "ms"
#中位值
echo "中位值:"`cat sqltime.log |grep "latency average"|awk '{print $4}'| sort -n | awk -f median.awk` "ms"
echo '######################################################################'
echo '测试tps：'
tail -12 /tmp/run.log
echo '######################################################################'
