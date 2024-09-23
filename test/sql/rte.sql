-- recursive common table expression
drop table if exists crte;
create table crte(director text, student varchar(20));
insert into crte values('tom', 'lily'), ('tom', 'smith'), ('lily', 'feifei'), ('feifei', 'bishop');
table crte;

with recursive relation as
(select * from crte
union all
select r.director, f.student from crte f, relation r
where r.student = f.director)
select * from relation order by director;
