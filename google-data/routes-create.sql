drop index if exists route_routeid_idx;
drop table if exists route;
create table route (
_id integer not null primary key autoincrement,
route_id int not null,
route_short_name varchar(40) default null,
route_long_name varchar(40) default null,
route_desc varchar(40) default null,
route_type int default 0,
route_url varchar(256) default null,
route_color varchar(8) default '000000',
route_text_color varchar(8)  default '000000'
);
create index route_routeid_idx on route('route_id');
