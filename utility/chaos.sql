create or replace function chaos_kill() returns boolean as 'regress.so', 'chaos_kill' language c;

-- kill all segment servers
select chaos_kill() from gp_dist_random('gp_id');

-- kill QD
--select chaos_kill();
