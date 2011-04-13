drop table if exists stop;
create table stop (
_id integer not null primary key autoincrement,
stop_id int not null, 
stop_name varchar(40) default null,
stop_desc varchar(40) default null, 
stop_lat float default 0, 
stop_lon float default 0);
