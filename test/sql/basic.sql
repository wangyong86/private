DROP TABLE IF EXISTS states cascade;

DROP TABLE IF EXISTS presidence cascade;

DROP TABLE IF EXISTS tenk cascade;

CREATE TABLE states (
    sname varchar(20) PRIMARY KEY,
	nation varchar not null,
    code int
);

CREATE TABLE presidence (
	name varchar primary key,
    sname char(20) REFERENCES states,
    age int check(age>10)
);

insert into states values('ohio', 'america', 10);
insert into states values('montna', 'america', 20);

-- null
insert into states values('florida', '', 20);
insert into states(sname, code) values('florida', 20);

insert into presidence values('wy', 'ohio', 20);

--invalid
insert into presidence values('ly', 'newyork', 20);
insert into presidence values('ly', 'ohio', 9);
insert into presidence values('wy', 'ohio', 20);

-- 
create table tenk (id int primary key, c1 int, c2_odd int, c3_even int, c4 float, c5 varchar);
insert into tenk select i, i, i*2+1, i*2, i, i || '_wy' from generate_series(1, 10000) i;
