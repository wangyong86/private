drop table if exists class;
create table class (cno int, nation int, num int);
explain insert into class values(1, 1, 20), (1, 2, 18), (1, 3, 12), (2, 1, 20), (2, 2, 2), (3, 1, 14), (3, 2, 8);
insert into class values(1, 1, 20), (1, 2, 18), (1, 3, 12), (2, 1, 20), (2, 2, 2), (3, 1, 14), (3, 2, 8);
explain (analyze,verbose) select cno, nation, num*100/sum(num) over (partition by cno) as present from class;  
select cno, nation, num*100/sum(num) over (partition by cno) as present from class;  

explain select * from class where cno >2;

explain select * from class where 2<3;
explain select * from class where 3<2;
--- result
