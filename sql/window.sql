drop table if exists grade;
create table grade(sno int, class int, math int, chinese int, english int);
insert into grade select i, (random()*3)::int + 1, (random()*100)::int, (random()*100)::int, (random()*100)::int from generate_series(1, 30)i;
table grade;
explain select *, rank() over (partition by class order by math desc) mrank, rank() over (partition by class order by chinese desc) crank, rank() over (partition by class order by english desc) erank from grade order by sno;
select *, rank() over (partition by class order by math desc) mrank, rank() over (partition by class order by chinese desc) crank, rank() over (partition by class order by english desc) erank from grade order by sno;
