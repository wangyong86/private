-- create
create table test_part(t date, nation int, revenue int)
using mars2
distributed by (nation) 
partition by range(t)
(start('1992-01-01') end ('1994-01-01') every(interval '1year'));

create index on test_part using mars2_btree(t);

insert into test_part select '1992-01-01', i /8, i from generate_series(1, 3600) i;
insert into test_part select '1993-01-01', i /8, i from generate_series(1, 3600) i;

analyze test_part;
