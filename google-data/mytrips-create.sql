drop table if exists mytrips;
create table mytrips (
trip_id int  not null primary key,
wstop_id int default 0,
hstop_id int default 0,
wsequence int default 0,
hsequence int default 0,
warrives char(8) default null,
wdeparts char(8) default null,
harrives char(8) default null,
hdeparts char(8) default null,
going_home int(1) default 0
);
drop index if exists mytrips_wstop_idx;
drop index if exists mytrops_hstop_idx;
create index mytrips_wstop_idx on mytrips('wstop_id');
create index mytrips_hstop_idx on mytrips('hstop_id');
