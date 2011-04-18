#!/usr/bin/env ruby

=begin rdoc

I created this script to parse all the csv data for the metro north railroad
csv files so that i could insert the data into a database. The only thing you
may have to adjust are how dates are handled in your database.
=end rdoc

input = $*
unless input[0]
  puts "usage: ./parse-data.rb dataname"
  exit 1
end
unless input[0].match /(agency|calendar|routes|shapes|stop_times|stops|routes|trips)/
  puts "un-supported input param #{input[0]}"
  exit 1
end
output = File.open("#{input[0]}-inserts.sql",'w')
lines=0
File.open("#{input[0]}.txt",'r').each do |f|
  if (f.length<=0)
    next
  end
  if (lines == 0)
    lines+=1
    output.puts "delete from #{input[0].gsub(/s$/,'')};"
    next
  end
  
  line = f.split(',')
  if line.length==0
    next
  end
  case input[0]
  when "agency"
    output.puts "insert into agency (agency_name, agency_url, agency_timezone) values ('#{line[0].gsub(/^ /,'').gsub(/ $/,'').gsub(/'/,"''")}','#{line[1].gsub(/^ /,'').gsub(/ $/,'').gsub(/'/,"''")}','#{line[2].gsub(/^ /,'').gsub(/ $/,'').gsub(/'/,"''").chomp}');"
  when "calendar"
    output.puts "insert into calendar (service_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday, start_date, end_date) values ('#{line[0].gsub(/^ /,'').gsub(/ $/,'').gsub(/'/,"''")}',#{line[1]},#{line[2]},#{line[3]},#{line[4]},#{line[5]},#{line[6]},#{line[7]},'#{line[8].gsub(/^ /,'').gsub(/ $/,'').gsub(/'/,"''")}','#{line[9].gsub(/^ /,'').gsub(/ $/,'').gsub(/'/,"''").chomp}');"
  when "calendar_dates"
    output.puts "insert into calendar_date (service_id,date,exception_type) values (#{line[0]},'#{line[1]}',#{line[2].chomp});"
  when "routes"
    output.puts "insert into route (route_id, route_short_name, route_long_name, route_desc, route_type) values (#{line[0]},'#{line[1].gsub(/^ /,'').gsub(/ $/,'').gsub(/'/,"''")}','#{line[2].gsub(/^ /,'').gsub(/ $/,'').gsub(/'/,"''")}','#{line[3].gsub(/^ /,'').gsub(/ $/,'').gsub(/'/,"''")}',#{line[4].chomp});"
  when "shapes"
    output.puts "insert into shape (shape_id, shape_pt_lat, shape_pt_lon, shape_pt_seq) values (#{line[0]},#{line[1]},#{line[2]},#{line[3].chomp});"
  when "stops"
    
    if line[3] and line[3].length == 0
      line[3] = "null";
    end
    
    output.puts "insert into stop (stop_id, stop_name, stop_desc, stop_lat, stop_lon) values (#{line[0]},'#{line[1].gsub(/^ /,'').gsub(/ $/,'').gsub(/'/,"''")}','#{line[2].gsub(/^ /,'').gsub(/ $/,'').gsub(/'/,"''")}',#{line[4].chomp},#{line[5].chomp});"
  when "stop_times"
    if line[1].class == String
      line[1].gsub!(/^ /,'')
      line[1].gsub!(/ $/,'')
      line[2].gsub!(/^ /,'')
      line[2].gsub!(/ $/,'')
    end
    if (line[1].length == 7)
      line[1] = "0" + line[1]
    end
    if (line[2].length == 7)
      line[2] = "0" + line[2]
    end
    output.puts "insert into stop_time (trip_id, arrival_time, departure_time, stop_id, stop_sequence, pickup_type, drop_off_type) values (#{line[0]},'#{line[1].gsub(/^ /,'').gsub(/ $/,'').gsub(/'/,"''")}','#{line[2].gsub(/^ /,'').gsub(/ $/,'').gsub(/'/,"''")}',#{line[3]},#{line[4]},#{line[5]},#{line[6].chomp});"
  when "trips"
    output.puts "insert into trip (route_id, service_id, trip_id, trip_headsign, shape_id) values (#{line[0]},'#{line[1].gsub(/^ /,'').gsub(/ $/,'').gsub(/'/,"''")}',#{line[2]},'#{line[3].gsub(/^ /,'').gsub(/ $/,'').gsub(/'/,"''")}',#{line[2].chomp});"
  else
    # this shouldn't happen
  end
  
  lines+=1
end

output.flush
output.close
