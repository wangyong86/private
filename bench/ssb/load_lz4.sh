#!/bin/env bash
tname=encode_51_t1

zstdcat /data1/wy/ssb/lineorder_flat.csv.zst | mxgate \
    --source stdin \
    --db-database ssb \
    --time-format raw \
    --format csv \
    --delimiter '|' \
    --target $tname\
    --interval 500 \
    --parallel=128 \
    --stream-prepared 6

psql -c "vacuum $tname" -c "analyze $tname" 
#psql -c "vacuum $tname" 


#insert into encode_51_t3 select * from encode_51 order by s_region, c_region, p_mfgr, s_nation, c_nation, p_category, lo_orderdate;
