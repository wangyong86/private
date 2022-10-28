--drop table if exists lineorder_flat;
\timing on
\set flattable lineorder_flat_aocs;
TRUNCATE TABLE :flattable;

INSERT INTO :flattable
SELECT
    l.lo_orderkey AS lo_orderkey,
    l.lo_linenumber AS lo_linenumber,
    l.lo_custkey AS lo_custkey,
    l.lo_partkey AS lo_partkey,
    l.lo_suppkey AS lo_suppkey,
    l.lo_orderdate AS lo_orderdate,
    l.lo_orderpriority AS lo_orderpriority,
    l.lo_shippriority AS lo_shippriority,
    l.lo_quantity AS lo_quantity,
    l.lo_extendedprice AS lo_extendedprice,
    l.lo_ordtotalprice AS lo_ordtotalprice,
    l.lo_discount AS lo_discount,
    l.lo_revenue AS lo_revenue,
    l.lo_supplycost AS lo_supplycost,
    l.lo_tax AS lo_tax,
    l.lo_commitdate AS lo_commitdate,
    l.lo_shipmode AS lo_shipmode,
    c.c_name AS c_name,
    c.c_address AS c_address,
    c.c_city AS c_city,
    c.c_nation AS c_nation,
    c.c_region AS c_region,
    c.c_phone AS c_phone,
    c.c_mktsegment AS c_mktsegment,
    s.s_name AS s_name,
    s.s_address AS s_address,
    s.s_city AS s_city,
    s.s_nation AS s_nation,
    s.s_region AS s_region,
    s.s_phone AS s_phone,
    p.p_name AS p_name,
    p.p_mfgr AS p_mfgr,
    p.p_category AS p_category,
    p.p_brand AS p_brand,
    p.p_color AS p_color,
    p.p_type AS p_type,
    p.p_size AS p_size,
    p.p_container AS p_container
FROM
    lineorder AS l
    INNER JOIN customer AS c ON c.c_custkey = l.lo_custkey
    INNER JOIN supplier AS s ON s.s_suppkey = l.lo_suppkey
    INNER JOIN part AS p ON p.p_partkey = l.lo_partkey;

