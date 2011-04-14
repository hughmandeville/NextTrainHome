select
t.trip_id,
st.arrival_time,
st.departure_time,
st.stop_sequence,
st.stop_id,
s.stop_name,
s.stop_lat,
s.stop_lon
from stop_time st, stop s, trip t, route r where
st.stop_id = s.stop_id and
st.trip_id = t.trip_id and
t.route_id = r.route_id and
t.service_id = 'weekday' and
r.route_long_name = 'New Haven Line'
order by t.trip_id, st.stop_sequence ;


/* Gets all of the stops for the new haven line during the week
FROM NEW HAVEN
INTO GRAND CENTRAL
*/
select
t.trip_id,
st.arrival_time,
st.departure_time,
st.stop_sequence,
st.stop_id,
s.stop_name,
s.stop_lat,
s.stop_lon
from stop_time st, stop s, trip t, route r where
st.stop_id = s.stop_id and
st.trip_id = t.trip_id and
t.route_id = r.route_id and
t.service_id = 'weekday' and
t.trip_headsign = 'New Haven_Inbound' and
r.route_long_name = 'New Haven Line'
order by t.trip_id, st.stop_sequence;

/* Gets all of the stops for the new haven line during the week

FROM GRAND CENTRAL 
TO NEW HAVEN

*/
select
t.trip_id,
st.arrival_time,
st.departure_time,
st.stop_sequence,
st.stop_id,
s.stop_name,
s.stop_lat,
s.stop_lon
from stop_time st, stop s, trip t, route r where
st.stop_id = s.stop_id and
st.trip_id = t.trip_id and
t.route_id = r.route_id and
t.service_id = 'weekday' and
t.trip_headsign = 'New Haven_Outbound' and
r.route_long_name = 'New Haven Line'
order by t.trip_id, st.stop_sequence;


select t.* from trip t, route r where
t.route_id = r.route_id and r.route_long_name = 'New Haven Line';


select *
from stop_time st, stop s, trip t, route r where
st.stop_id = s.stop_id and
st.trip_id = t.trip_id and
t.route_id = r.route_id and
t.service_id = 'weekday' and
r.route_long_name = 'New Haven Line'
order by t.trip_id, st.stop_id, st.stop_sequence desc;


/*
Get all stops into GC for a given station
*/
select
t.trip_id,
st.arrival_time,
st.departure_time,
st.stop_sequence,
st.stop_id,
s.stop_name,
s.stop_lat,
s.stop_lon
from stop_time st, stop s, trip t, route r where
st.stop_id = s.stop_id and
st.trip_id = t.trip_id and
t.route_id = r.route_id and
t.service_id = 'weekday' and
/*t.trip_headsign = 'New Haven_Inbound' and*/
r.route_long_name = 'New Haven Line'  and (s.stop_id = 140 or s.stop_name = 'Bridgeport' )
order by t.trip_id, st.stop_sequence;

select
t.trip_id,
st.arrival_time,
st.departure_time,
st.stop_sequence,
st.stop_id,
s.stop_name,
s.stop_lat,
s.stop_lon
from stop_time st, stop s, trip t, route r where
st.stop_id = s.stop_id and
st.trip_id = t.trip_id and
t.route_id = r.route_id and
t.service_id = 'weekday' and
/*t.trip_headsign = 'New Haven_Inbound' and*/
r.route_long_name = 'New Haven Line'  and (s.stop_id = 140 or s.stop_name = 'Bridgeport' ) and
strftime('%s',date('now') || departure_time) > strftime('%s','now')
order by t.trip_id, st.stop_sequence;

/**
 Get all inbound to gd for a stop after now
**/
select
t.trip_id,
st.arrival_time,
st.departure_time,
st.stop_sequence,
st.stop_id,
s.stop_name,
s.stop_lat,
s.stop_lon
from stop_time st, stop s, trip t, route r where
st.stop_id = s.stop_id and
st.trip_id = t.trip_id and
t.route_id = r.route_id and
t.service_id = 'weekday' and
/*t.trip_headsign = 'New Haven_Inbound' and*/
r.route_long_name = 'New Haven Line'  and (s.stop_id = 140 or s.stop_name = 'Bridgeport' ) and
strftime('%s',date('now') || departure_time) > strftime('%s','now')
order by t.trip_id, st.stop_sequence;

select
t.trip_id,
st.arrival_time,
st.departure_time,
st.stop_sequence,
st.stop_id,
s.stop_name,
s.stop_lat,
s.stop_lon,
time('now', 'localtime') time_now
from stop_time st, stop s, trip t, route r where
st.stop_id = s.stop_id and
st.trip_id = t.trip_id and
t.route_id = r.route_id and
t.service_id = 'weekday' and
(s.stop_id = 140 or s.stop_name = 'Bridgeport' ) and
departure_time > time('now', 'localtime')
order by arrival_time, t.trip_id, st.stop_sequence;

(s.stop_id = 1 and st.stop_sequence = 1)

select t.trip_id,st.arrival_time,st.departure_time,st.stop_sequence,st.stop_id,s.stop_name,s.stop_lat,s.stop_lon,time('now', 'localtime') time_now
from stop_time st, stop s, trip t, route r where
st.stop_id = s.stop_id and st.trip_id = t.trip_id and t.route_id = r.route_id and t.service_id = 'weekday' and
(s.stop_id = 140 and st.stop_sequence > 1 ) 
and
departure_time > time('now', 'localtime')
order by arrival_time, t.trip_id, st.stop_sequence;

st.trip_id = (select trip_id from stop_time where st.stop_id = 1 and st.stop_sequence  = 1)

select strftime('%H:%M:%S',departure_time) from stop_times limit 5;

select strftime('%H:%M:%S', 'now')

select strftime('%s', strftime('%H:%M:%S','now'))+1800
select strftime('%s', date('now') || departure_time ) from stop_time limit 5
select count(1) from stop_time where 
strftime('%s',departure_time) > strftime('%s', strftime('%H:%M:%S','now')) +1800

select count(1) from stop_time where 
(strftime('%s',date('now') || departure_time) < (strftime('%s', strftime('%H:%M:%S','now'))+1800)) and 
(strftime('%s',date('now') || departure_time) > (strftime('%s', strftime('%H:%M:%S','now')) -1800)) ;



select count(1) from stop_time where 
(strftime('%s',date('now') || departure_time) < (strftime('%s','now')+1800)) and 
(strftime('%s',date('now') || departure_time) > (strftime('%s','now')-1800)) ;





/*
Get all trains from that arrive at bridgeport
*/
select t.trip_id,st.arrival_time,st.departure_time,st.stop_sequence,st.stop_id,s.stop_name,s.stop_lat,s.stop_lon,time('now', 'localtime') time_now
from stop_time st, stop s, trip t, route r where
st.stop_id = s.stop_id and st.trip_id = t.trip_id and t.route_id = r.route_id and t.service_id = 'weekday' and
(s.stop_id = 140 and st.stop_sequence > 1 ) 
and
departure_time > time('now', 'localtime')
and 
st.trip_id in (select distinct(trip_id) from stop_time where stop_id = 1 and stop_sequence  = 1)
order by arrival_time, t.trip_id, st.stop_sequence


/**
Getting closer - trains from gc that stop at bridgeport
**/

select t.trip_id, st.departure_time departure_time ,null arrival_time,st.stop_sequence,st.stop_id,s.stop_name,s.stop_lat,s.stop_lon,time('now', 'localtime') time_now
from stop_time st, stop s, trip t, route r where
st.stop_id = s.stop_id and st.trip_id = t.trip_id and t.route_id = r.route_id and t.service_id = 'weekday' and
(s.stop_id = 1 and st.stop_sequence = 1 ) 
and
departure_time > time('now', 'localtime')
and 
st.trip_id in (select distinct(trip_id) from stop_time where stop_id = 140 and stop_sequence  > 1)
union 
select t.trip_id,null departure_time,st.arrival_time,st.stop_sequence,st.stop_id,s.stop_name,s.stop_lat,s.stop_lon,time('now', 'localtime') time_now
from stop_time st, stop s, trip t, route r where
st.stop_id = s.stop_id and st.trip_id = t.trip_id and t.route_id = r.route_id and t.service_id = 'weekday' and
(s.stop_id = 140 and st.stop_sequence > 1 ) 
and
departure_time > time('now', 'localtime')
and 
st.trip_id in (select distinct(trip_id) from stop_time where stop_id = 1 and stop_sequence  = 1)
order by t.trip_id, st.stop_sequence


03-24 07:15:12.076: ERROR/AndroidRuntime(372): java.lang.RuntimeException: Unable to start activity ComponentInfo{com.mymnrtt/com.mymnrtt.Splash}: java.lang.RuntimeException: Unable to start activity ComponentInfo{com.mymnrtt/com.mymnrtt.TrainTimesActivity}: java.lang.RuntimeException: Your content must have a ListView whose id attribute is 'android.R.id.list'


/**
Gets the depart and arrive time from GC to BP 
after NOW
**/
select start.trip_id, departure_time departs, dest.arrival_time arrives, dest.stops from stop_time start, trip,
(
  /* get the arival time for the destination */
  select trip_id, arrival_time, stop_sequence stops from stop_time where
  arrival_time > time('now', 'localtime') and 
  stop_id = 140 and stop_sequence > 1 and trip_id in 
   (
    /* make sure the destination is on the same trip as the source */
    select distinct(trip_id) from stop_time where 
    stop_id = 1 and 
    departure_time > time('now', 'localtime')
   )
) dest where
dest.trip_id = start.trip_id and /* join on the trip */
start.trip_id = trip.trip_id and 
departure_time > time('now', 'localtime') and /* no need to show older trains */
start.stop_id = 1 and 
start.trip_id in (select distinct(trip_id) from stop_time where stop_id = 140 and stop_sequence  > 1) and
trip.service_id = 'weekday'
order by 2,3,1


select s.trip_id,departure_time departs, a.arrival_time arrives from stop_time s, 
(select trip_id, arrival_time from stop_time where
arrival_time > time('now', 'localtime') and 
stop_id = 140 and stop_sequence > 1 and trip_id in (select distinct(trip_id) from stop_time where stop_id = 1 and stop_sequence  = 1 and departure_time > time('now', 'localtime'))) a where
a.trip_id = s.trip_id and
departure_time > time('now', 'localtime') and 
stop_id = 1 and 
stop_sequence = 1 and 
s.trip_id in (select distinct(trip_id) from stop_time where stop_id = 140 and stop_sequence  > 1) and
s.trip_id in (select trip_id from trip where service_id = 'weekday')
order by 2,3,1


select s.trip_id,departure_time departs, a.arrival_time arrives from stop_time s, 
(select trip_id, arrival_time from stop_time where
arrival_time > time('now', 'localtime') and 
stop_id = 1 and stop_sequence > 1 and trip_id in (select distinct(trip_id) from stop_time where stop_id = 140 and stop_sequence  < 5 and departure_time > time('now', 'localtime'))) a where
a.trip_id = s.trip_id and
departure_time > time('now', 'localtime') and 
stop_id = 140 and 
stop_sequence = 1 and 
s.trip_id in (select distinct(trip_id) from stop_time where stop_id = 1 and stop_sequence  > 1) and
s.trip_id in (select trip_id from trip where service_id = 'weekday')
order by 2,3,1


/**
Train trips from BP to GC
**/

select start.trip_id, departure_time departs, dest.arrival_time, dest.stops arrives from stop_time start, trip,
(
  /* get the arival time for the destination */
  select trip_id, arrival_time, stop_sequence stops from stop_time where
  arrival_time > time('now', 'localtime') and 
  stop_id = 1 and stop_sequence > 1 and trip_id in 
   (
    /* make sure the destination is on the same trip as the source */
    select distinct(trip_id) from stop_time where 
    stop_id = 140 and 
    departure_time > time('now', 'localtime')
   )
) dest where
dest.trip_id = start.trip_id and /* join on the trip */
start.trip_id = trip.trip_id and 
departure_time > time('now', 'localtime') and /* no need to show older trains */
start.stop_id = 140 and 
start.trip_id in (select distinct(trip_id) from stop_time where stop_id = 1 and stop_sequence  > 1) and
trip.service_id = 'weekday'
order by 2,3,1





select start.trip_id, departure_time departs, dest.arrival_time arrives, dest.stops nstops from stop_time start, trip,(  /* get the arival time for the destination */  select trip_id, arrival_time, stop_sequence stops from stop_time where  arrival_time > time('now', 'localtime') and   stop_id = 1 and stop_sequence > 1 and trip_id in    (    /* make sure the destination is on the same trip as the source */    select distinct(trip_id) from stop_time where     stop_id = 140 and     departure_time > time('now', 'localtime')   )) dest where dest.trip_id = start.trip_id and /* join on the trip */ start.trip_id = trip.trip_id and departure_time > time('now', 'localtime') and /* no need to show older trains */ start.stop_id = 140 and start.trip_id in (select distinct(trip_id) from stop_time where stop_id = 1 and stop_sequence  > 1) and trip.service_id = 'weekday' order by 2,3,1



select start.trip_id, departure_time departs, dest.arrival_time arrives, dest.stops nstops from stop_time start, trip, calendar,
(
  /* get the arival time for the destination */
  select trip_id, arrival_time, stop_sequence stops from stop_time where
  arrival_time > time('now', 'localtime') and 
  stop_id = 1 and stop_sequence > 1 and trip_id in 
   (
    /* make sure the destination is on the same trip as the source */
    select distinct(trip_id) from stop_time where 
    stop_id = 140 and 
    departure_time > time('now', 'localtime')
   ) 
) dest where
dest.trip_id = start.trip_id and /* join on the trip */
start.trip_id = trip.trip_id and 
trip.service_id = calendar.service_id and
departure_time > time('now', 'localtime') and /* no need to show older trains */
start.stop_id = 140 and 
start.trip_id in (select distinct(trip_id) from stop_time where stop_id = 1 and stop_sequence  > 1) and 
calendar.thursday = 1
order by 2,3,1

/**
GC to Bridgeport
**/
select start.trip_id, departure_time departs, dest.arrival_time arrives, dest.stops nstops from stop_time start, trip, calendar,
(
  /* get the arival time for the destination */
  select trip_id, arrival_time, stop_sequence stops from stop_time where
  arrival_time > time('now', 'localtime') and 
  stop_id = 140 and stop_sequence > 1 and trip_id in 
   (
    /* make sure the destination is on the same trip as the source */
    select distinct(trip_id) from stop_time where 
    stop_id = 1 and 
    departure_time > time('now', 'localtime')
   ) 
) dest where
dest.trip_id = start.trip_id and /* join on the trip */
start.trip_id = trip.trip_id and 
trip.service_id = calendar.service_id and
departure_time > time('now', 'localtime') and /* no need to show older trains */
start.stop_id = 1 and 
start.trip_id in (select distinct(trip_id) from stop_time where stop_id = 140 and stop_sequence  > 1) and 
calendar.thursday = 1
order by 2,3,1 limit 10




select start.trip_id, departure_time departs, dest.arrival_time arrives, dest.stops nstops from stop_time start, trip, calendar,
(
  /* get the arival time for the destination */
  select trip_id, arrival_time, stop_sequence stops from stop_time where
  arrival_time > time('now', 'localtime') and 
  stop_id = (select stop_id from mystops where _id = 1) and stop_sequence > 1 and trip_id in 
   (
    /* make sure the destination is on the same trip as the source */
    select distinct(trip_id) from stop_time where 
    stop_id = (select stop_id from mystops where _id = 2) and 
    departure_time > time('now', 'localtime')
   ) 
) dest where
dest.trip_id = start.trip_id and /* join on the trip */
start.trip_id = trip.trip_id and 
trip.service_id = calendar.service_id and
departure_time > time('now', 'localtime') and /* no need to show older trains */
start.stop_id = (select stop_id from mystops where _id = 2) and 
start.trip_id in (select distinct(trip_id) from stop_time where stop_id = (select stop_id from mystops where _id = 1) and stop_sequence  > 1) and 
calendar.thursday = 1
order by 2,3,1 limit 10

(
calendar.sunday = ? and
calendar.monday = ? and
calendar.tuesday = ? and
calendar.wednesday = ? and
calendar.thursday = ? and
calendar.friday = ? and
calendar.saturday = ? 
)


drop table if exists mytrips;
create  table mytrips (
trip_id int  not null primary key,
wstop_id int default 0,
hstop_id int default 0,
wsequence int default 0,
hsequence int default 0,
warrives char(8) default null,
wdeparts char(8) default null,
harrives char(8) default null,
hdeparts char(8) default null,
going_home int(1) default 0
);
create index mytrips_wstopid_idx on mytrips(wstop_id);
create index mytrips_hstopid_idx on mytrips(wstop_id);


drop table if exists worktrips;
create table worktrips (
trip_id int  not null primary key,
wstop_id int default 0,
wsequence int default 0,
warrives char(8) default null,
wdeparts char(8) default null
);
drop table if exists hometrips;
create table hometrips (
trip_id int  not null primary key,
hstop_id int default 0,
hsequence int default 0,
harrives char(8) default null,
hdeparts char(8) default null
);

delete from hometrips;
insert into 
hometrips (trip_id, hstop_id,hsequence,harrives,hdeparts) 
select t.trip_id, stop_id, stop_sequence, arrival_time, departure_time from trip t, stop_time s
where
t.trip_id = s.trip_id and stop_id = 140
and t.trip_id in (
select t.trip_id from trip t, stop_time s
where
t.trip_id = s.trip_id and stop_id = 1
)

delete from worktrips;
insert into 
worktrips (trip_id,wstop_id,wsequence,warrives,wdeparts) 
select t.trip_id, stop_id, stop_sequence, arrival_time,departure_time
from trip t, stop_time s
where
t.trip_id = s.trip_id and stop_id = 1
and t.trip_id in (
select t.trip_id from trip t, stop_time s
where
t.trip_id = s.trip_id and stop_id = 140
)

delete from mytrips;
insert into mytrips (
trip_id,
hstop_id,
hsequence,
harrives,
hdeparts,
wstop_id,
wsequence,
warrives,
wdeparts) select h.trip_id, hstop_id, hsequence, harrives,hdeparts, wstop_id, wsequence, warrives, wdeparts from
hometrips h, worktrips w where
h.trip_id = w.trip_id;

update mytrips set going_home = 1 where hsequence > wsequence;

vacuum;



select 
start.trip_id, 
departure_time departs, 
arrival_time arrives, 
from 
stop_time start, 
trip, 
calendar,
mytrips
where
dest.trip_id = start.trip_id and /* join on the trip */
start.trip_id = trip.trip_id and 
trip.service_id = calendar.service_id and
departure_time > time('now', 'localtime') and /* no need to show older trains */
start.stop_id = (select stop_id from mystops where _id = 2) and 
start.trip_id in (select distinct(trip_id) from stop_time where stop_id = (select stop_id from mystops where _id = 1) and stop_sequence  > 1) and 
calendar.thursday = 1
order by 2,3,1 limit 10



select m.trip_id, wstop_id, hstop_id, d.departure_time departs, a.arrival_time arrives 
from
mytrips m 
inner join stop_time a on (a.trip_id = m.trip_id and a.stop_id = m.wstop_id)
inner join stop_time d on (d.trip_id = m.trip_id and d.stop_id = m.hstop_id)
inner join trip t on (t.trip_id = m.trip_id)
inner join calendar c on (c.trip_id = t.trip_id)
where  m.going_home = 0
and (
calendar.tuesday=(strftime('%w','now','localtime')=0)
)


select m.trip_id, t.service_id, wstop_id, hstop_id, d.departure_time departs, a.arrival_time arrives 
from
mytrips m 
inner join stop_time a on (a.trip_id = m.trip_id and a.stop_id = m.wstop_id)
inner join stop_time d on (d.trip_id = m.trip_id and d.stop_id = m.hstop_id)
inner join trip t on (t.trip_id = m.trip_id)
inner join calendar c on (c.service_id = t.service_id)
where  m.going_home = 0
and (
c.tuesday = (abs(strftime('%w','now','localtime'))=2)
)
order by departs


select distinct m.trip_id _id, t.service_id, d.departure_time departs, a.arrival_time arrives 
from
mytrips m 
inner join stop_time a on (a.trip_id = m.trip_id and a.stop_id = m.wstop_id)
inner join stop_time d on (d.trip_id = m.trip_id and d.stop_id = m.hstop_id)
inner join trip t on (t.trip_id = m.trip_id)
inner join calendar c on (c.service_id = t.service_id)
where  m.going_home = 0
and (
c.monday = nullif(0,abs(strftime('%w','now','localtime'))=1) 
)
order by departs


drop table if exists boolcalendar;
drop index if exists boolcalendar_service_idx;
create table boolcalendar (
_id integer not null primary key autoincrement,
service_id int default 0,
available int default 0
);
create index boolcalendar_service_idx on boolcalendar(service_id);


/*
Get my trips to work
*/
select  m.trip_id _id, t.service_id, strftime('%H:%M',d.departure_time) departs, strftime('%H:%M',a.arrival_time) arrives 
from
mytrips m 
inner join stop_time a on (a.trip_id = m.trip_id and a.stop_id = m.wstop_id)
inner join stop_time d on (d.trip_id = m.trip_id and d.stop_id = m.hstop_id)
inner join trip t on (t.trip_id = m.trip_id)
inner join calendar c on (c.service_id = t.service_id)
where  m.going_home = 0
and (
(c.sunday & (abs(strftime('%w','now','localtime'))=0)) or
(c.monday & (abs(strftime('%w','now','localtime'))=1)) or
(c.tuesday & (abs(strftime('%w','now','localtime'))=2)) or
(c.wednesday & (abs(strftime('%w','now','localtime'))=3)) or
(c.wednesday & (abs(strftime('%w','now','localtime'))=4)) or
(c.thursday & (abs(strftime('%w','now','localtime'))=5)) or
(c.saturday & (abs(strftime('%w','now','localtime'))=6)) 
)
order by departs,arrives

/*
Get my trips home
*/
select  m.trip_id _id, t.service_id, strftime('%H:%M',d.departure_time) departs, strftime('%H:%M',a.arrival_time) arrives 
from
mytrips m 
inner join stop_time a on (a.trip_id = m.trip_id and a.stop_id = m.hstop_id)
inner join stop_time d on (d.trip_id = m.trip_id and d.stop_id = m.wstop_id)
inner join trip t on (t.trip_id = m.trip_id)
inner join calendar c on (c.service_id = t.service_id)
where  m.going_home = 1
and (
(c.sunday & (abs(strftime('%w','now','localtime'))=0)) or
(c.monday & (abs(strftime('%w','now','localtime'))=1)) or
(c.tuesday & (abs(strftime('%w','now','localtime'))=2)) or
(c.wednesday & (abs(strftime('%w','now','localtime'))=3)) or
(c.wednesday & (abs(strftime('%w','now','localtime'))=4)) or
(c.thursday & (abs(strftime('%w','now','localtime'))=5)) or
(c.saturday & (abs(strftime('%w','now','localtime'))=6)) 
)
order by departs,arrives


select t.service_id, d.departure_time departs, a.arrival_time arrives 
from
mytrips m 
inner join stop_time a on (a.trip_id = m.trip_id and a.stop_id = m.wstop_id)
inner join stop_time d on (d.trip_id = m.trip_id and d.stop_id = m.hstop_id)
inner join trip t on (t.trip_id = m.trip_id)
inner join calendar c on (c.service_id = t.service_id)
where  m.going_home = 0
and (
(c.sunday & (abs(strftime('%w','now','localtime'))=0)) or
(c.monday & (abs(strftime('%w','now','localtime'))=1)) or
(c.tuesday & (abs(strftime('%w','now','localtime'))=2)) or
(c.wednesday & (abs(strftime('%w','now','localtime'))=3)) or
(c.wednesday & (abs(strftime('%w','now','localtime'))=4)) or
(c.thursday & (abs(strftime('%w','now','localtime'))=5)) or
(c.saturday & (abs(strftime('%w','now','localtime'))=6)) 
)
order by departs,arrives





if (REQUIRED_SIZE > mywidth) {
   nwidth = mywidth-REQUIRED_SIZE;
   percent = nwidth/mywidth;
   nheight = myheight-(percent*myheight);
}


{
    "data": {
        "user_id": "59281910",
        "entitlements": {
            "crosswords": {
                "expires": "2012-03-26 0:00:00",
                "expiration_date": "2012-03-26 0:00:00"
            },
            "timesreader": {
                "expires": "2012-03-26 0:00:00",
                "expiration_date": "2012-03-26 0:00:00"
            },
            "mm": {
                "expiration_date": "2012-03-26 0:00:00",
                "expires": "2012-03-26 0:00:00"
            },
            "mow": {
                "expires": "2012-03-26 0:00:00",
                "expiration_date": "2012-03-26 0:00:00"
            },
            "msd": {
                "expires": "2012-03-26 0:00:00",
                "expiration_date": "2012-03-26 0:00:00"
            },
            "mtd": {
                "expires": "2012-03-26 0:00:00",
                "expiration_date": "2012-03-26 0:00:00"
            }
        }
    }
}






select  m.trip_id _id, t.service_id, d.departure_time departs, a.arrival_time arrives, 0 day
from
mytrips m 
inner join stop_time a on (a.trip_id = m.trip_id and a.stop_id = m.wstop_id)
inner join stop_time d on (d.trip_id = m.trip_id and d.stop_id = m.hstop_id)
inner join trip t on (t.trip_id = m.trip_id)
inner join calendar c on (c.service_id = t.service_id)
where  m.going_home = 0
and (
(c.sunday & (1=0)) or
(c.monday & (1=0)) or
(c.tuesday & (1=0)) or
(c.wednesday & (1=0)) or
(c.wednesday & (1=0)) or
(c.thursday & (1=1)) or
(c.saturday & (1=0)) 
)
union
select  m.trip_id _id, t.service_id, d.departure_time departs, a.arrival_time arrives, 1 day 
from
mytrips m 
inner join stop_time a on (a.trip_id = m.trip_id and a.stop_id = m.wstop_id)
inner join stop_time d on (d.trip_id = m.trip_id and d.stop_id = m.hstop_id)
inner join trip t on (t.trip_id = m.trip_id)
inner join calendar c on (c.service_id = t.service_id)
where  m.going_home = 0
and (
(c.sunday & (1=0)) or
(c.monday & (1=0)) or
(c.tuesday & (1=0)) or
(c.wednesday & (1=0)) or
(c.thursday & (1=0)) or
(c.friday & (1=0)) or
(c.saturday & (1=1)) 
)
order by day,departs,arrives




select  m.trip_id _id, t.service_id, d.departure_time departs
from
mytrips m 
inner join stop_time a on (a.trip_id = m.trip_id and a.stop_id = m.wstop_id)
inner join trip t on (t.trip_id = m.trip_id)
inner join calendar c on (c.service_id = t.service_id)
where  m.going_home = 0
and (
(c.sunday & (1=0)) or
(c.monday & (1=0)) or
(c.tuesday & (1=0)) or
(c.wednesday & (1=0)) or
(c.thursday & (1=0)) or
(c.friday & (1=0)) or
(c.saturday & (1=1)) 
)
order by departs

select 
