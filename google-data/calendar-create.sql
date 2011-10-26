drop table if exists calendar;
drop index if exists calender_monday_idx;
drop index if exists calender_tuesday_idx;
drop index if exists calender_wednesday_idx;
drop index if exists calender_thursday_idx;
drop index if exists calender_friday_idx;
drop index if exists calender_saturday_idx;
drop index if exists calender_sunday_idx;

create table calendar (
_id integer not null primary key autoincrement,
service_id varchar(20) not null,
monday tinyint(1) default 0,
tuesday tinyint(1) default 0,
wednesday tinyint(1) default 0,
thursday tinyint(1) default 0,
friday tinyint(1) default 0,
saturday tinyint(1) default 0,
sunday tinyint(1) default 0,
start_date varchar(8) not null,
end_date varchar(8) not null);

create index calender_monday_idx on calendar('monday');
create index calender_tuesday_idx on calendar('tuesday');
create index calender_wednesday_idx on calendar('wednesday');
create index calender_thursday_idx on calendar('thursday');
create index calender_friday_idx on calendar('friday');
create index calender_saturday_idx on calendar('saturday');
create index calender_sunday_idx on calendar('sunday');


