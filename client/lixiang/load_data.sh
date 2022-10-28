#!/bin/bash

TAG_BEGIN=1
TAG_PREFIX=DUMMY_DEVICE_
TAGS=30000
BATCH_LINE=4
BATCH_SIZE=500
PERCENT_IDLE_EMPTY=96
PERCENT_SINGLE_LINE=90
PERCENT_RUN_EMPTY=60
DB=mxdb_poc
TARGET=st_signal_mars2
PERCENT_OUT_ORDER=1
OUT_ORDER_DUR=7200

./lixiang_v11 \
--percent-of-single-line ${PERCENT_SINGLE_LINE} \
--batch-line ${BATCH_LINE} \
--batch-size ${BATCH_SIZE} \
--percent-of-idle-empty ${PERCENT_IDLE_EMPTY} \
--percent-of-running-tag 15 \
--running-batch-line ${BATCH_LINE} \
--percent-of-running-empty ${PERCENT_RUN_EMPTY} \
--column-num 5000 \
--delimiter '|' \
--duration 1 \
--json-start 854 \
--tag-begin ${TAG_BEGIN} \
--tag-num ${TAGS} \
--tag-prefix ${TAG_PREFIX} \
--start-time '2021-12-22 00:00:00' \
--end-time '2021-12-24 00:00:00' \
--template-size 3600 \
--rate 0 \
--percent-of-out-order ${PERCENT_OUT_ORDER} \
--out-order-duration ${OUT_ORDER_DUR} \
| \
mxgate --source stdin \
--db-database ${DB} \
--db-master-host localhost \
--db-master-port 19000 \
--db-user liuruyi \
--time-format raw \
--format csv \
--delimiter "|" \
--target ${TARGET} \
--parallel 256 \
--interval 250
