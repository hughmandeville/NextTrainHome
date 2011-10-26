drop table if exists hometrips;
create table hometrips (
trip_id int  not null primary key,
hstop_id int default 0,
hsequence int default 0,
harrives char(8) default null,
hdeparts char(8) default null
);
create index hometrips_hstop_idx on hometrips('hstop_id');
