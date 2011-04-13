drop table if exists route;
create table route (
_id integer not null primary key autoincrement,
route_id int not null,
route_short_name varchar(40) default null,
route_long_name varchar(40) default null,
route_desc varchar(40) default null,
route_type int default 0);
