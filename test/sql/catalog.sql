SELECT
    n.nspname AS "Schema",
    c.relname AS "Name",
    CASE c.relkind
    WHEN 'r' THEN
        'table'
    WHEN 'v' THEN
        'view'
    WHEN 'm' THEN
        'materialized view'
    WHEN 'i' THEN
        'index'
    WHEN 'S' THEN
        'sequence'
    WHEN 's' THEN
        'special'
    WHEN 'f' THEN
        'foreign table'
    END AS "Type",
    pg_catalog.pg_get_userbyid(c.relowner) AS "Owner",
    CASE c.relstorage
    WHEN 'h' THEN
        'heap'
    WHEN 'x' THEN
        'external'
    WHEN 'a' THEN
        'append only'
    WHEN 'v' THEN
        'none'
    WHEN 'c' THEN
        'append only columnar'
    WHEN 'm' THEN
        'mars3'
    WHEN 'p' THEN
        'Apache Parquet'
    WHEN 'f' THEN
        'foreign'
    END AS "Storage",
    pg_catalog.pg_size_pretty(pg_catalog.pg_table_size(c.oid)) AS "Size",
    pg_catalog.obj_description(c.oid, 'pg_class') AS "Description"
FROM
    pg_catalog.pg_class c
    LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
WHERE
    c.relkind IN ('r', 'v', 'm', 'S', 'f', '')
    AND c.relstorage IN ('h', 'a', 'c', 'm', 'x', 'f', 'v', '')
    AND n.nspname <> 'pg_catalog'
    AND n.nspname <> 'information_schema'
    AND n.nspname !~ '^pg_toast'
    AND pg_catalog.pg_table_is_visible(c.oid)
ORDER BY
    1,
    2;

