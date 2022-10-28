#!/bin/bash

#创建测试数据库
#dropdb mxdb_poc
createdb mxdb_poc

#执行ddl
psql -d mxdb_poc -f ./ddl/st_signal_mars2.ddl
psql -d mxdb_poc -f ./ddl/trans2.sql

