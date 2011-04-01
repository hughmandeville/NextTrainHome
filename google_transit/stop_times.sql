drop table if exists stop_time;
drop index if exists trip_id_idx;
drop index if exists stop_id_idx;
drop index if exists arrival_time_idx;
drop index if exists departure_time_idx;
drop index if exists stop_sequence_idx;
create table stop_time (
_id integer not null primary key autoincrement,
trip_id int not null,
arrival_time varchar(8) not null,
departure_time varchar(8) not null,
stop_id int not null,
stop_sequence int default 0,
pickup_type int default 0,
drop_off_type int default 0);

create index trip_id_idx on stop_time(trip_id);
create index stop_id_idx on stop_time(stop_id);
create index arrival_time_idx on stop_time(arrival_time);
create index departure_time_idx on stop_time(departure_time);
create index stop_sequence_idx on stop_time(stop_sequence);
