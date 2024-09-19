drop table if exists api;

-- scalar
select '5'::json;

-- general
select '{"key":10, "value":"wy", "active":true}'::json;

-- array
select '[1, 2, "foo", false, null]'::json;

-- nested
select '{"foo":{"a":1, "b":false}, "bar":[1, 2, false]}'::json;

-- plain numeric
SELECT '{"reading": 1.230e-5}'::json, '{"reading": 1.230e-5}'::jsonb;

-- include and exist

select '"foo"'::jsonb @> '"foo"'::jsonb;

-- Index
create table api (jdoc json, jbdoc jsonb);
create index on api using gin(jdoc jsonb_path_ops);
insert into api values('{
    "guid": "9c36adc1-7fb5-4d5b-83b4-90356a46061a",
    "name": "Angela Barton",
    "is_active": true,
    "company": "Magnafone",
    "address": "178 Howard Place, Gulf, Washington, 702",
    "registered": "2009-11-07T08:53:22 +08:00",
    "latitude": 19.793713,
    "longitude": 86.513373,
    "tags": [
        "enim",
        "aliquip",
        "qui"
    ]
}'::json,
 '{
    "guid": "9c36adc1-7fb5-4d5b-83b4-90356a46061a",
    "name": "Angela Barton",
    "is_active": true,
    "company": "Magnafone",
    "address": "178 Howard Place, Gulf, Washington, 702",
    "registered": "2009-11-07T08:53:22 +08:00",
    "latitude": 19.793713,
    "longitude": 86.513373,
    "tags": [
        "enim",
        "aliquip",
        "qui"
    ]
}'::jsonb);
select * from api;

-- found
explain select jdoc->'guid', jdoc->'name' from api where jdoc @> '{"company": "Magnafone"}';
select jdoc->'guid', jdoc->'name' from api where jdoc @> '{"company": "Magnafone"}';

-- can't use index, ? can't be used on indexed column
explain select jdoc->'guid', jdoc->'name' from api where jdoc -> 'tags' ? 'qui';
select jdoc->'guid', jdoc->'name' from api where jdoc -> 'tags' ? 'qui';

-- index on some path
create index on api using gin((jdoc->'tags'));

explain select jdoc->'guid', jdoc->'name' from api where jdoc @@ '$.tags[*] == "qui"';
select jdoc->'guid', jdoc->'name' from api where jdoc @@ '$.tags[*] == "qui"';

explain select jdoc->'guid', jdoc->'name' from api where jdoc @? '$.tags[*] ? (@ == "qui")';
select jdoc->'guid', jdoc->'name' from api where jdoc @? '$.tags[*] ? (@ == "qui")';
