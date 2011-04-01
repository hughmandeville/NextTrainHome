drop table if exists calendar_date;
create table calendar_date (
 _id integer not null primary key autoincrement,
 service_id int not null,
 date varchar(8) not null,
 exception_type int
);
