:EXPLAIN_ANALYZE

select sum(lo_extendedprice * lo_discount) as revenue
  from :tname
-- 需要改下时间范围，看群里面记录
 where lo_orderdate >= '1994-01-31'
   and lo_orderdate <  '1994-02-04'
   and lo_discount between 5 and 7
   and lo_quantity between 26 and 35
;