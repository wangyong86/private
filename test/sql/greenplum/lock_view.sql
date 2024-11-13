\set schema ymatrix_utils
\set only_final 1

drop schema :schema cascade;
create schema if not exists :schema;

create or replace view :schema.locks as
select gp_segment_id as segmentid
     , mppsessionid as sessionid
     , pid
     , granted
     , (case
        when locktype in ('relation', 'extend') then
            format('%s[database=%s, relation=%s]',
                   locktype, database, relation::regclass::name)
        when locktype = 'page' then
            format('%s[database=%s, relation=%s, page=%s]',
                   locktype, database, relation::regclass::name, page)
        when locktype = 'tuple' then
            format('%s[database=%s, relation=%s, ctid=(%s,%s)]',
                   locktype, database, relation::regclass::name, page, tuple)
        when locktype in ('transactionid', 'distributed xid') then
            format('%s[%s]', locktype, transactionid)
        when locktype = 'virtualxid' then
            format('%s[%s]', locktype, virtualxid)
        when locktype in ('object', 'userlock', 'advisory') then
            format('%s[database=%s, classid=%s, objid=%s, objsubid=%s]',
				   locktype, database, classid, objid, objsubid)
        when locktype = 'resource queue' then
            format('%s[objid=%s]', locktype, objid)
        when locktype = 'frozenid' then
            format('%s[database=%s]', locktype, database)
        else
            format('%s[database=%s, relation=%s, page=%s, tuple=%s, virtualxid=%s, transactionid=%s, classid=%s, objid=%s, objsubid=%s]',
				   locktype, database, relation, page, tuple, virtualxid, transactionid, classid, objid, objsubid)
        end
       ) as reason
  from pg_locks
;

create or replace view :schema.edges as
select w.segmentid
     , w.sessionid as waiter_sessionid
     , w.pid as waiter_pid
     , h.sessionid as holder_sessionid
     , h.pid as holder_pid
     , h.reason
     , format('con%s,p%s --{%s}--> con%s,p%s',
              w.sessionid, w.pid, h.reason, h.sessionid, h.pid) as path
  from :schema.locks as w
  join :schema.locks as h
    on h.sessionid != w.sessionid
   and h.segmentid = w.segmentid
   and h.reason = w.reason
 where not w.granted
   and h.granted
;

create or replace view :schema.waitgraph as
with
recursive waiters as (
    select * from :schema.edges
    union all
    select w.segmentid
         , w.waiter_sessionid
         , w.waiter_pid
         , h.holder_sessionid
         , h.holder_pid
         , h.reason
         , format('%s --{%s}--> con%s,p%s',
                  w.path, h.reason, h.holder_sessionid, h.holder_pid) as path
      from waiters as w
      join :schema.edges as h
        on w.holder_sessionid = h.waiter_sessionid
)
\if :only_final
, endpoint_waiters as (
    select waiter_sessionid as sessionid
      from :schema.edges
     where waiter_sessionid not in (select holder_sessionid from :schema.edges)
)
, endpoint_holders as (
    select holder_sessionid as sessionid
      from :schema.edges
     where holder_sessionid not in (select waiter_sessionid from :schema.edges)
)
\endif
select m.*
  from waiters m
\if :only_final
 where m.waiter_sessionid in (select sessionid from endpoint_waiters)
   and m.holder_sessionid in (select sessionid from endpoint_holders)
\endif
;

select * from :schema.waitgraph;
