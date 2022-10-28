-- target table, change it if necessary
\set tname mars2_lz4_3enum_encode
\set srcflat lineorder_flat_aocs

\set e_lo_orderpriority text
\set e_lo_shipmode text
\set e_c_city text
\set e_s_city text
\set e_s_nation text
\set e_c_nation text
\set e_c_mktsegment text
\set e_p_category text
\set e_p_brand text
\set e_p_color text
\set e_p_type text
\set e_p_container text

\set locale collate "C"

drop table if exists :tname;
\timing
\set default_encode encoding(encodechain='''lz4''', compresstype='mxcustom')
\set default_encode_mm encoding(minmax, encodechain='''lz4''', compresstype='mxcustom')
\set simple8b encoding(encodechain='''simple8b''', compresstype='mxcustom')
\set simple8b_mm encoding(minmax, encodechain='''simple8b''', compresstype='mxcustom')
\set varint encoding(encodechain='''deltazigzag''', compresstype='mxcustom')
\set varint_mm encoding(minmax, encodechain='''deltazigzag''', compresstype='mxcustom')
\set scalevarint_mm encoding(minmax, encodechain='''deltazigzag''', compresstype='mxcustom')

create table :tname
 ( lo_orderkey      int
 , lo_linenumber    smallint               :simple8b
 , lo_custkey       int                    :varint
 , lo_partkey       int                    :varint
 , lo_suppkey       int                    :default_encode
 , lo_orderdate     date              :scalevarint_mm
 , lo_orderpriority text     :default_encode
 , lo_shippriority  smallint               :default_encode
 , lo_quantity      smallint               :simple8b_mm
 , lo_extendedprice int
 , lo_ordtotalprice int
 , lo_discount      int                    :simple8b_mm
 , lo_revenue       int
 , lo_supplycost    int                    :default_encode
 , lo_tax           smallint               :simple8b
 , lo_commitdate    date              :default_encode
 , lo_shipmode      text       :locale   :default_encode
 , c_name           text       :locale            :default_encode
 , c_address        text       :locale            :default_encode
 , c_city           text       :locale        :default_encode_mm
 , c_nation         :e_c_nation             :default_encode_mm
 , c_region         e_c_region             :default_encode_mm
 , c_phone          text       :locale            :default_encode
 , c_mktsegment     text       :locale  :default_encode
 , s_name           text       :locale            :default_encode
 , s_address        text       :locale            :default_encode
 , s_city           text       :locale        :default_encode_mm
 , s_nation         :e_s_nation             :default_encode_mm
 , s_region         e_s_region             :default_encode_mm
 , s_phone          text       :locale            :default_encode
 , p_name           text       :locale            :default_encode
 , p_mfgr           e_p_mfgr               :default_encode_mm
 , p_category       text       :locale    :default_encode_mm
 , p_brand          text       :locale       :default_encode_mm
 , p_color          text       :locale       :default_encode
 , p_type           text       :locale        :default_encode
 , p_size           smallint               :simple8b
 , p_container      text       :locale   :default_encode
 )
 using mars2
 distributed by (lo_orderdate)
 partition by range (lo_orderdate)
 (start(timestamp '1992-01-01') end(timestamp '1999-01-01') every(interval '1 year') )
;

create index on :tname using mars2_btree(s_region, c_region, p_mfgr, s_nation, c_nation, p_category);

insert into :tname select
   lo_orderkey      :: int
 , lo_linenumber    :: int
 , lo_custkey       :: int
 , lo_partkey       :: int
 , lo_suppkey       :: int
 , lo_orderdate     :: date
 , lo_orderpriority :: e_lo_orderpriority
 , lo_shippriority  :: int
 , lo_quantity      :: int
 , lo_extendedprice :: int
 , lo_ordtotalprice :: int
 , lo_discount      :: int
 , lo_revenue       :: int
 , lo_supplycost    :: int
 , lo_tax           :: int
 , lo_commitdate    :: date
 , lo_shipmode      :: :e_lo_shipmode
 , c_name           :: text
 , c_address        :: text
 , c_city           :: :e_c_city
 , c_nation         :: :e_c_nation
 , c_region         :: e_c_region
 , c_phone          :: text
 , c_mktsegment     :: :e_c_mktsegment
 , s_name           :: text
 , s_address        :: text
 , s_city           :: :e_s_city
 , s_nation         :: :e_s_nation
 , s_region         :: e_s_region
 , s_phone          :: text
 , p_name           :: text
 , p_mfgr           :: e_p_mfgr
 , p_category       :: :e_p_category
 , p_brand          :: :e_p_brand
 , p_color          :: :e_p_color
 , p_type           :: :e_p_type
 , p_size           :: int
 , p_container      :: :e_p_container
 from :srcflat
;
