CREATE OR REPLACE FUNCTION public.list_partition(nspname text,relname text, out parent regclass, out relname regclass, out starttime timestamptz,out endtime timestamptz , out info text, out storage_type text)
    RETURNS setof record
    LANGUAGE sql
    AS $function$
        SELECT
            i.inhparent::regclass,
            c.oid::pg_catalog.regclass,
            case when pg_catalog.pg_get_expr(c.relpartbound, c.oid)='DEFAULT'  then '-infinity'::timestamptz else to_timestamp(split_part( pg_catalog.pg_get_expr(c.relpartbound, c.oid),'''',2),'YYYY-MM-DD HH24:MI:SS') end as start_time,
            case when pg_catalog.pg_get_expr(c.relpartbound, c.oid)='DEFAULT'  then 'infinity'::timestamptz else to_timestamp(split_part( pg_catalog.pg_get_expr(c.relpartbound, c.oid),'''',4),'YYYY-MM-DD HH24:MI:SS') end as end_time,
            pg_size_pretty(pg_total_relation_size(c.oid::pg_catalog.regclass)),
            a.amname||E'\t' || coalesce('with(' ||array_to_string(reloptions , ', ')||E')','')
        FROM
            pg_catalog.pg_class c, pg_catalog.pg_inherits i,  pg_am a
        WHERE
            c.oid=i.inhrelid AND  c.relam=a.oid
            AND i.inhparent in (select oid from pg_class where relkind='p' and relnamespace::regnamespace::text in ($1) and relname in  ($2) )
        order by 3 ;
    $function$;
