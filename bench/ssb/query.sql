\timing on
\o query.log

---Q1.1
select sum(lo_extendedprice * lo_discount) as revenue
  from mars3_enum
 where lo_orderdate >= '1993-01-01'::timestamp
   and lo_orderdate <  '1994-01-01'::timestamp
   and lo_discount between 1 and 3
   and lo_quantity < 25
;

---Q1.2
select sum(lo_extendedprice * lo_discount) as revenue
  from mars3_enum
 where lo_orderdate >= '1994-01-01'::timestamp
   and lo_orderdate <  '1994-02-01'::timestamp
   and lo_discount between 4 and 6
   and lo_quantity between 26 and 35
;

---Q1.3
select sum(lo_extendedprice * lo_discount) as revenue
  from mars3_enum
 where lo_orderdate >= '1994-01-31'::timestamp
   and lo_orderdate <  '1994-02-04'::timestamp
   and lo_discount between 5 and 7
   and lo_quantity between 26 and 35
;

---Q2.1
select sum(lo_revenue)
     , time_bucket('365 day', lo_orderdate) as year
     , p_brand
  from mars3_enum
 where p_category = 'MFGR#12'
   and s_region = 'AMERICA'
 group by year
        , p_brand
 order by year
        , p_brand
;

---Q2.2
select sum(lo_revenue)
     , time_bucket('365 day', lo_orderdate) as year
     , p_brand
  from mars3_enum
 where p_brand >= 'MFGR#2221'
   and p_brand <= 'MFGR#2228'
   and s_region = 'ASIA'
 group by year
        , p_brand
 order by year
        , p_brand
;

---Q2.3
select sum(lo_revenue)
     , time_bucket('365 day', lo_orderdate) as year
     , p_brand
  from mars3_enum
 where p_brand = 'MFGR#2239'
   and s_region = 'EUROPE'
 group by year
        , p_brand
 order by year
        , p_brand
;

---Q3.1
select c_nation
     , s_nation
     , time_bucket('365 day', lo_orderdate) as year
     , sum(lo_revenue) as revenue
  from mars3_enum
 where c_region = 'ASIA'
   and s_region = 'ASIA'
   and lo_orderdate >= '1992-01-01'
   and lo_orderdate <  '1998-01-01'
 group by c_nation
        , s_nation
        , year
 order by year asc
        , revenue desc
;

---Q3.2
select c_city
     , s_city
     , time_bucket('365 day', lo_orderdate) as year
     , sum(lo_revenue) as revenue
  from mars3_enum
 where c_nation = 'UNITED STATES'
   and s_nation = 'UNITED STATES'
   and lo_orderdate >= '1992-01-01'
   and lo_orderdate <  '1998-01-01'
 group by c_city
        , s_city
        , year
 order by year asc
        , revenue desc
;

---Q3.3
select c_city
     , s_city
     , time_bucket('365 day', lo_orderdate) as year
     , sum(lo_revenue) as revenue
  from mars3_enum
 where c_city in ('UNITED KI1', 'UNITED KI5')
   and s_city in ('UNITED KI1', 'UNITED KI5')
   and lo_orderdate >= '1992-01-01'
   and lo_orderdate <  '1998-01-01'
 group by c_city
        , s_city
        , year
 order by year asc
        , revenue desc
;

---Q3.4
select c_city
     , s_city
     , time_bucket('365 day', lo_orderdate) as year
     , sum(lo_revenue) as revenue
  from mars3_enum
 where c_city in ('UNITED KI1', 'UNITED KI5')
   and s_city in ('UNITED KI1', 'UNITED KI5')
   and lo_orderdate >= '1997-12-01'
   and lo_orderdate <  '1998-01-01'
 group by c_city
        , s_city
        , year
 order by year asc
        , revenue desc
;

---Q4.1
select time_bucket('365 day', lo_orderdate) as year
     , c_nation
     , sum(lo_revenue - lo_supplycost) as profit
  from mars3_enum
 where c_region = 'AMERICA'
   and s_region = 'AMERICA'
   and p_mfgr in ('MFGR#1', 'MFGR#2')
 group by year
        , c_nation
 order by year asc
        , c_nation asc
;

---Q4.2
select time_bucket('365 day', lo_orderdate) as year
     , c_nation
     , p_category
     , sum(lo_revenue - lo_supplycost) as profit
  from mars3_enum
 where c_region = 'AMERICA'
   and s_region = 'AMERICA'
   and lo_orderdate >= '1997-01-01'
   and lo_orderdate <  '1998-01-01'
   and p_mfgr in ('MFGR#1', 'MFGR#2')
 group by year
        , c_nation
        , p_category
 order by year asc
        , c_nation asc
        , p_category asc
;

---Q4.3
select time_bucket('365 day', lo_orderdate) as year
     , s_city
     , p_brand
     , sum(lo_revenue - lo_supplycost) as profit
  from mars3_enum
 where s_nation = 'UNITED STATES'
   and lo_orderdate >= '1997-01-01'
   and lo_orderdate <  '1998-01-01'
   and p_category = 'MFGR#14'
 group by year
        , s_city
        , p_brand
 order by year asc
        , s_city asc
        , p_brand asc
;
