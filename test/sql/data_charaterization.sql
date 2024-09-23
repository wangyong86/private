-- table
SELECT
    column_name,
    data_type,
    character_maximum_length,
    is_nullable,
    column_default
FROM
    information_schema.columns
WHERE
    table_name = 'your_table';

--Sampling 
SELECT * FROM your_table ORDER BY RANDOM() LIMIT 100; 
SELECT * FROM your_table TABLESAMPLE BERNOULLI (10);
SELECT
    tablename,
    attname AS column,
    n_distinct,
    null_frac,
    avg_width,
    most_common_vals,
    most_common_freqs,
    histogram_bounds
FROM
    pg_stats
WHERE
    tablename = 'your_table';
    
-- distribution    
DROP TYPE IF EXISTS wh_stats CASCADE;
CREATE TYPE wh_stats AS (
    rel            regclass
  , attnum         int
  , attname        name
  , atttypname     text
  , avg_length     float8
  , max_length     bigint
  , min_length     bigint
  , count          bigint
  , count_non_null bigint
  , n_distinct     bigint
);

DROP FUNCTION IF EXISTS collect_stats;
CREATE OR REPLACE FUNCTION collect_stats(rel regclass)
RETURNS SETOF wh_stats AS $$
DECLARE
  col RECORD;
  query text;
  query2 text;
  ret wh_stats;
BEGIN
  query := 'SELECT attnum, attname, atttypid, CASE WHEN atttypid::regtype = ''character varying''::regtype THEN atttypmod-4 ELSE -1 END AS mod FROM pg_attribute WHERE attrelid = $1 AND attnum >= 0 ORDER BY attnum';
  FOR col IN EXECUTE query USING rel LOOP
    query2 := format('SELECT %L::regclass, %L::int, %L::name
                 , CASE WHEN %s >=0 THEN %L::regtype::text || ''('' || %s || '')'' ELSE %L::regtype::text END
                 , avg(length(%I::text))::float8
                 , max(length(%I::text))::bigint
                 , min(length(%I::text))::bigint
                 , count(1)::bigint
                 , count(%I)::bigint
                 , count(distinct %I)::bigint
              FROM %I;', rel, col.attnum, col.attname, col.mod, col.atttypid, col.mod, col.atttypid, col.attname, col.attname, col.attname, col.attname, col.attname, rel);
    raise notice '%', query2;
    EXECUTE query2 INTO ret;
    RETURN NEXT ret;
  END LOOP;
END
$$ LANGUAGE PLPGSQL VOLATILE;
-- SELECT * FROM collect_stats('your_table_name'::regclass);

