drop table if exists worktrips;
CREATE TABLE worktrips (
trip_id int  not null primary key,
wstop_id int default 0,
wsequence int default 0,
warrives char(8) default null,
wdeparts char(8) default null
);
create index wometrips_wstop_idx on worktrips('wstop_id');
