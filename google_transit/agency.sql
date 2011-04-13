drop table if exists agency;
create table agency (
_id integer not null primary key autoincrement,
agency_name varchar(40) not null,
agency_url varchar(100) not null,
agency_timezone varchar(40) not null
);
