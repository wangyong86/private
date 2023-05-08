#!/usr/bin/env bash

columns="c_city c_nation c_region c_mktsegment \
    lo_orderpriority lo_shipmode \
    p_mfgr p_category p_brand p_color p_type p_container \
    s_city s_nation s_region"

dbname=ssb
tname=lineorder_flat_aocs

Q()
{
    psql -d "$dbname" -P pager=off -Atq "$@"
}

for column in $columns; do
    echo >&2 "$column ..."
    enum=e_$column

    cat <<EOF
set enable_groupagg to off;
set enable_hashagg to on;

select 'drop type if exists $enum;';
select 'create type $enum as enum ( ' || string_agg(quote_literal(c), ', ') || ' );'
  from (select $column as c from $tname group by 1 order by 1) as t;
EOF
done | Q | Q
