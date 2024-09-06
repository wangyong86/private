CREATE TEMPORARY TABLE sample (letter, junk) AS
SELECT substring(relname, 1, 1), repeat('x', 250)
FROM pg_class
ORDER BY random()
DISTRIBUTED MASTERONLY; -- add rows in random order

CREATE INDEX i_sample on sample (letter);

vacuum sample;
analyze sample;

WITH letters (letter, count) AS (
SELECT letter, COUNT(*)
FROM sample
GROUP BY 1
)
SELECT letter, count, (count * 100.0 / (SUM(count) OVER ()))::numeric(4,1) AS "%"
FROM letters
ORDER BY 2 DESC;

CREATE OR REPLACE FUNCTION lookup_letter(text) RETURNS SETOF text AS $$
BEGIN
RETURN QUERY EXECUTE ' 
EXPLAIN SELECT letter
FROM sample
WHERE letter = ''' || $1 || '''';
END
$$ LANGUAGE plpgsql;

WITH letter (letter, count) AS (
SELECT letter, COUNT(*)
FROM sample
GROUP BY 1
)
SELECT letter AS l, count, lookup_letter(letter)
FROM letter
ORDER BY 2 DESC;

