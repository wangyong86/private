#!/usr/bin/env bash

gpconfig -c shared_preload_libraries -v "matrixts,matrixmgr,matrixgate,telemetry,mxvector"
gpstop -rqai

createdb ssb
export PGDATABASE=ssb

psql -c "create extension matrixts cascade"
psql -c "create extension mxvector cascade"
