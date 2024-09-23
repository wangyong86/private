drop table if exists tt;
drop segment_set if exists ss_protect;
drop tablespace  if exists ts_protect;
create segment_set ss_protected segments('0');
create tablespace ts_protected location '/home/wy/protected_domain';
create table tt(c1 int, c2 text encoding(safesuffix));
