DROP TABLE IF EXISTS stu;

DROP TABLE IF EXISTS course;

DROP TABLE IF EXISTS scc;

CREATE TABLE stu (
    id int,
    name varchar) distributed masteronly;

CREATE TABLE course (
    id int,
    name varchar) distributed masteronly;

CREATE TABLE scc (
    id int,
    cid int,
    score int) distributed masteronly;

INSERT INTO stu
    VALUES (1, 'wy'),
    (2, 'ly');

INSERT INTO course
    VALUES (1, 'chinese'),
    (2, 'math'),
    (3, 'english');

INSERT INTO scc
    VALUES (1, 1, 100),
    (1, 2, 90),
    (1, 2, 80),
    (2, 1, 90),
    (2, 2, 100);

