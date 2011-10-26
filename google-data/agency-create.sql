drop table if exists agency;
create table agency (
_id integer not null primary key autoincrement,
agency_name varchar(40) not null,
agency_url varchar(100) default null,
agency_timezone varchar(40) default null
);
create index agency_agency_name on agency('agency_name');
