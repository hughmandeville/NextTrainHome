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
