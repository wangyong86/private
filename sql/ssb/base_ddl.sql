--sql
\set smode 'using ao_column with (compresstype=zstd)'
drop table if exists customer;
create table customer
(
        c_custkey       int,
        c_name          text,
        c_address       text,
        c_city          text,
        c_nation        text,
        c_region        text,
        c_phone         text,
        c_mktsegment    text,
        c_trailing      int,

        primary key (c_custkey)
)
;

drop table if exists lineorder;
create table lineorder
(
    lo_orderkey             int,
    lo_linenumber           int,
    lo_custkey              int,
    lo_partkey              int,
    lo_suppkey              int,
    lo_orderdate            timestamp,
    lo_orderpriority        text,
    lo_shippriority         int,
    lo_quantity             int,
    lo_extendedprice        int,
    lo_ordtotalprice        int,
    lo_discount             int,
    lo_revenue              int,
    lo_supplycost           int,
    lo_tax                  int,
    lo_commitdate           timestamp,
    lo_shipmode             text,
    lo_trailing             int
)
:smode
;

drop table if exists part;
create table part
(
        p_partkey       int,
        p_name          text,
        p_mfgr          text,
        p_category      text,
        p_brand         text,
        p_color         text,
        p_type          text,
        p_size          int,
        p_container     text,
        p_trailing      int,

        primary key (p_partkey)
)
;

drop table if exists supplier;
create table supplier
(
        s_suppkey       int,
        s_name          text,
        s_address       text,
        s_city          text,
        s_nation        text,
        s_region        text,
        s_phone         text,
        s_trailing      int,

        primary key (s_suppkey)
)
;
