drop index if exists t_route_idx;
drop index if exists t_service_idx;
drop index if exists t_trip_idx;
drop index if exists t_shape_idx;

drop table if exists trip;



create table trip (
_id integer not null primary key autoincrement,
route_id int not null,
service_id int not null, 
trip_id int not null, 
trip_headsign varchar(40) not null, 
shape_id int not null
);

create index if not exists t_route_idx on trip (route_id);
create index if not exists t_service_idx on trip (service_id);
create index if not exists t_trip_idx on trip (trip_id);
create index if not exists t_shape_idx on trip (shape_id);
