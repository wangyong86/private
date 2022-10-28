-- 创建UDF（一次性）
DROP FUNCTION IF EXISTS signal_explore;
CREATE OR REPLACE FUNCTION signal_explore(
  tablename name,
  vin       text,
  st        timestamp,
  et        timestamp,
  signals   text[]
) RETURNS SETOF text
AS $$
DECLARE
  with_clause text = '';
  with_part   text = '';
  sig         text;
BEGIN
  IF array_length(signals, 1) <= 0 THEN
    RAISE EXCEPTION '"signals" must NOT be empty';
  END IF; 

  FOREACH sig IN ARRAY signals
  LOOP
    IF with_clause <> '' THEN 
      with_part := '
    UNION ALL';
    END IF;
    with_part := with_part || format('
      SELECT json_build_object(''signalName'', %L, ''dps'', json_object(t.k, t.d))
      FROM (
        SELECT array_agg(extract(epoch from ts)::text) k,
               array_agg((%s)::text) d
        FROM %s z
        WHERE z.ts >= $1
          AND z.ts < $2
          AND z.vin = $3
          AND z.%s IS NOT NULL
      ) t', sig, sig, tablename, sig);
    with_clause := with_clause || with_part;
  END LOOP;

  RETURN QUERY EXECUTE format('WITH details(j) AS (
    %s
  )
  SELECT
    jsonb_pretty(json_build_object(
      ''code'', 0,
      ''msg'' , ''Success'',
      ''data'', json_build_object(
        ''vinCode''  , vin,
        ''startTime'', extract(epoch from $1) * 1000,
        ''endTime''  , extract(epoch from $2) * 1000
      ),
      ''signals'', ARRAY((SELECT * FROM details))
  )::jsonb)
  FROM %s
  WHERE ts >= $1 AND ts < $2 AND vin = $3
  GROUP BY vin
  ', with_clause, tablename) USING st, et, vin;
END
$$ LANGUAGE PLPGSQL VOLATILE EXECUTE ON MASTER;

-- 用法示例
SELECT * FROM signal_explore(
  'public.st_signal_mars2',
  '361',
  '2021-11-17 10:00:50'::timestamp,
  '2021-11-17 12:01:00'::timestamp,
  ARRAY['c1', 'c20', 'c300', 'cg1->>''c1234''', 'cg1->>''c2345''']
);
