#!/bin/bash

export T385_NUM_INSERTS=100
export T385_TEST_CV=yes
export T385_USE_CV=yes
export T385_TEST_MAIN=no
export T385_TEST_GATE=no
export T385_TEST_CYLN=no
export T385_NO_TAB=yes

testbin=/home/wy/lxdev4/test/table385test
COUNTER=10000

source common.sh

trap "ps -ef|grep $chaoskill|grep -v grep|awk '{print "\""kill -9 "\""\$2}'|sh" 0 1 2 3 15
sh $chaoskill & 

gpstart -a || true
mkdir -p ./${OUTDIR}
cd ./${OUTDIR}

while true
do
  echo "$(date): Run ${COUNTER}" | tee -a $runtimelog
  mkdir -p ${COUNTER}
  date > ${COUNTER}/start.log

  rm -rf ~/gpAdminLogs/* || true
  # rm -rf ${MASTER_DATA_DIRECTORY}/log/gpdb*.csv   ### clear pg_log
  # gpstop -arf > ${COUNTER}/pre_restartdb.log 2>&1 || true  ### restart gpdb
  mxgate stop > ${COUNTER}/pre_mxgate_stop.log 2>&1 || true
  mxgate stop -f >> ${COUNTER}/pre_mxgate_stop.log 2>&1 || true
  dropdb t500 > ${COUNTER}/pre_db.log 2>&1 || true
  createdb t500 >> ${COUNTER}/pre_db.log 2>&1 || true
  psql -d t500 -c "create extension matrixts; create extension mars;" 2>&1 >> ${COUNTER}/pre_db.log || true

  $testbin > ${COUNTER}/go_test_out.log 2>&1
  if [ $? -ne 0 ]; then
    psql -d t500 -c "select * from matrixts_internal.apm_action_log;" > ${COUNTER}/action.log 2>&1 || true
    psql -d t500 -c "select * from matrixts_internal.apm_operation_log;" >> ${COUNTER}/action.log 2>&1 || true
    psql -d t500 -c "select * from pg_class order by oid desc limit 10;" >> ${COUNTER}/action.log 2>&1 || true
    echo "test failed ${COUNTER}, collecting log and schema"
    pg_dump --file ${COUNTER}/fail_schema.sql -s -d t500 || true
    cp -r ~/gpAdminLogs ${COUNTER} || true
    # cp -r ${MASTER_DATA_DIRECTORY}/log ${COUNTER}/pg_log || true  #### collect pg_log
    date > ${COUNTER}/finish.log
    mv ${COUNTER} "${COUNTER}.fail"

	corefiles=`find /home/wy/matrixdb -name "core*"`
	if [ $? != 0 ]; then
		echo "Found core: $corefiles"
		#exit 1 #### stop test on fail
	fi

  else
	date > ${COUNTER}/finish.log || true
  fi

  echo "$(date): ${COUNTER} finished, sleep for 10s" |tee -a $runtimelog
  sleep 10
  COUNTER=$((COUNTER+1))
  export T385_SECONDS=120 ###### tune
done
