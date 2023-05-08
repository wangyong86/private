#!/usr/bin/env bash

gpconfig -c shared_preload_libraries -v "matrixts,matrixmgr,matrixgate,telemetry,mars,mxvector"
gpstop -rqai

gpconfig -c matrix.enable_mxvector -v true

gpstop -rqai

createdb ssb
export PGDATABASE=ssb

psql -c "create extension matrixts cascade"
psql -c "create extension mxvector cascade"
