#!/bin/bash

#删除数据
#dropdb mxdb_poc
psql -d mxdb_poc -c "drop table st_signal_mars2 cascade;"

