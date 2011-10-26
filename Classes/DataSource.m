//
//  DataSource.m
//  
//  Contains methods for getting meeting location and other information from the SQLite database.
//
//  Created by Hubert Mandeville on 11/6/10.
//  Copyright 2011 Soul Doubt Productions. All rights reserved.
//


#import "DataSource.h"


static DataSource *sharedInstance = nil;

static NSString *WEB_SERVICE_DB_LAST_MODIFIED = @"http://www.souldoubtprod.com/nexttrainhome/get_last_modified.php";
static NSString *WEB_SERVICE_DB_FILE = @"http://www.souldoubtprod.com/nexttrainhome/data/nexttrainhome.sqlite";


@implementation DataSource

@synthesize locationManager;
@synthesize currentLocation;

-(NSString *)getSql:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SQLStatements" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *sql = [dict objectForKey:name];
    //NSLog(@"We have %@", sql);
    return sql;
}

/*
 * This message reciever will get all of the stops so the user can choose one as
 * their home stops. Returns a dictionary of arrays e.g. getObjectForKey:@stopIds getObjectForKey:@stopNames
 */
-(NSArray *)getAllStops
{
    sqlite3 *database;
	int ret = 0;
    NSString *sql = [self getSql:@"getStationsSql"];
    NSMutableArray *ids = [[NSMutableArray alloc] init];
    NSMutableArray *names = [[NSMutableArray alloc] init];
    
    if((ret = sqlite3_open([databasePath UTF8String], &database)) == SQLITE_OK) 
    {
     
        // Setup the SQL Statement and compile it for faster access
		sqlite3_stmt *compiledStatement;
		if ((ret = sqlite3_prepare_v2(database, [sql cStringUsingEncoding:NSASCIIStringEncoding], -1, &compiledStatement, NULL)) == SQLITE_OK) 
        {
			// Loop through the results and update the distance
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
            {
                NSInteger pk = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)] integerValue];
                NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                [names addObject:name];
                [ids addObject:[NSNumber numberWithInt:pk]];
            }
        } else {
             NSCAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
        sqlite3_finalize(compiledStatement);
        sqlite3_close(database);
    }
    if (ret != 0) 
    {
        NSLog(@"error with sqlite %s", sqlite3_errmsg(database));
    }
    NSLog(@"we have this many pks: %i",[ids count]);
    
    NSArray *result = [[[NSArray alloc] initWithObjects:ids, names, nil] autorelease];
    [names release];
    [ids release];
    return result;
}

-(void)setHomeStop:(NSNumber *)homeStopId
{
    // This sql has one param to set with %i
    NSString *sql = [self getSql:@"saveHomeSql"];
    sql = [NSString stringWithFormat:sql,[homeStopId intValue]];
    sqlite3 *database;
	int ret = 0;
    if((ret = sqlite3_open([databasePath UTF8String], &database)) == SQLITE_OK) 
    {
        // Setup the SQL Statement and compile it for faster access
		sqlite3_stmt *compiledStatement;
        if ((ret = sqlite3_prepare_v2(database, [sql cStringUsingEncoding:NSASCIIStringEncoding], -1, &compiledStatement, NULL)) == SQLITE_OK) 
        {
            sqlite3_step(compiledStatement);
            sqlite3_finalize(compiledStatement);
            
            sql = [self getSql:@"updateTripsSql"];
            sqlite3_exec(database,[sql cStringUsingEncoding:NSASCIIStringEncoding], NULL,NULL,NULL);
        } 
        else 
        {
            NSLog(@"Problem executing %@", sql);
        }
    }
    if (ret != 0) 
    {
        NSLog(@"error with sqlite %s", sqlite3_errmsg(database));
    }
}

-(void)setWorkStop:(NSNumber *)workStopId
{
    // This sql has one param to set with %i
    NSString *sql = [self getSql:@"saveWorkSql"];
    sql = [NSString stringWithFormat:sql,[workStopId intValue]];
    sqlite3 *database;
	int ret = 0;
    if((ret = sqlite3_open([databasePath UTF8String], &database)) == SQLITE_OK) 
    {
        // Setup the SQL Statement and compile it for faster access
		sqlite3_stmt *compiledStatement;
        if ((ret = sqlite3_prepare_v2(database, [sql cStringUsingEncoding:NSASCIIStringEncoding], -1, &compiledStatement, NULL)) == SQLITE_OK) 
        {
            sqlite3_step(compiledStatement); 
            sqlite3_finalize(compiledStatement);
            
            //sql = [NSString stringWithFormat:sql];
            if ((ret = sqlite3_prepare_v2(database, [sql cStringUsingEncoding:NSASCIIStringEncoding], -1, &compiledStatement, NULL)) == SQLITE_OK) 
                
            {
                sqlite3_step(compiledStatement);
                sqlite3_finalize(compiledStatement);
                NSLog(@"updated my trips");
            }
            else
            {
                NSLog(@"unable to update the db with %@", sql);
            }
            
        } 
        else 
        {
            NSLog(@"Problem executing %@", sql);
        }
    }
    if (ret != 0) 
    {
        NSLog(@"error with sqlite %s", sqlite3_errmsg(database));
    }
}

-(NSDictionary *)getHomeStop
{
    
    sqlite3 *database;
	int ret = 0;
    NSString *sql = [self getSql:@"getHomeSql"];
    NSLog(@"We have %@", sql);
    NSNumber *pk = nil;
    NSString *name = nil;
    
    if((ret = sqlite3_open([databasePath UTF8String], &database)) == SQLITE_OK) 
    {
        
        // Setup the SQL Statement and compile it for faster access
		sqlite3_stmt *compiledStatement;
		if ((ret = sqlite3_prepare_v2(database, [sql cStringUsingEncoding:NSASCIIStringEncoding], -1, &compiledStatement, NULL)) == SQLITE_OK) 
        {
			// Loop through the results and update the distance
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
            {
                pk = [NSNumber numberWithInt:[[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)] integerValue]];
                name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
            }
        } else {
            NSCAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
        sqlite3_finalize(compiledStatement);
        sqlite3_close(database);
    }
    if (ret != 0) 
    {
        NSLog(@"error with sqlite %s", sqlite3_errmsg(database));
    }
    
    NSLog(@"we have this pks: %@",pk);
    NSDictionary *dict = [[[NSDictionary alloc] initWithObjectsAndKeys:pk, @"pk", name, @"name",nil] autorelease];
    return dict;    
}
-(NSNumber *)getHomeStopId
{
    NSDictionary *dict = [self getHomeStop];
    return [dict objectForKey:@"pk"];
}
-(NSDictionary *)getWorkStop
{
    sqlite3 *database;
	int ret = 0;
    NSString *sql = [self getSql:@"getWorkSql"];
    NSLog(@"We have %@", sql);
    NSNumber *pk = nil;
    NSString *name = nil;
    
    if((ret = sqlite3_open([databasePath UTF8String], &database)) == SQLITE_OK) 
    {
        
        // Setup the SQL Statement and compile it for faster access
		sqlite3_stmt *compiledStatement;
		if ((ret = sqlite3_prepare_v2(database, [sql cStringUsingEncoding:NSASCIIStringEncoding], -1, &compiledStatement, NULL)) == SQLITE_OK) 
        {
			// Loop through the results and update the distance
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
            {
                pk = [NSNumber numberWithInt:[[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)] integerValue]];
                name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
            }
        } else {
            NSCAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
        sqlite3_finalize(compiledStatement);
        sqlite3_close(database);
    }
    if (ret != 0) 
    {
        NSLog(@"error with sqlite %s", sqlite3_errmsg(database));
    }
    
    NSLog(@"we have this pks: %@",pk);
    NSDictionary *dict = [[[NSDictionary alloc] initWithObjectsAndKeys:pk, @"pk", name, @"name",nil] autorelease];
    return dict; 
}


-(NSNumber *)getWorkStopId
{
    NSDictionary *dict = [self getWorkStop];
    return [dict objectForKey:@"pk"];
}


//
// TODO: Update to only calculate for day and time searching for, to reduce search time.
// CLLocationDegrees lat = 41.945296;
// CLLocationDegrees lng = -71.27562;
// CLLocation *location = [[[CLLocation alloc] initWithLatitude:lat longitude:lng] autorelease];
//
-(void) calculateStopsDistancesFrom:(CLLocation *)location {
	
	sqlite3 *database;
	int ret = 0;
    
	NSString* sql = [NSString stringWithFormat:@"SELECT l.id, l.latitude, l.longitude, l.distance, l.from_location, m.day_of_week FROM location l "
					 "INNER JOIN meeting m ON m.location_id = l.id WHERE (from_location is null) OR (from_location != '%f,%f') ",
					 location.coordinate.latitude, location.coordinate.longitude];
    
	
	if((ret = sqlite3_open([databasePath UTF8String], &database)) == SQLITE_OK) {
		
		// Setup the SQL Statement and compile it for faster access
		sqlite3_stmt *compiledStatement;
		if ((ret = sqlite3_prepare_v2(database, [sql cStringUsingEncoding:NSASCIIStringEncoding], -1, &compiledStatement, NULL)) == SQLITE_OK) {
			// Loop through the results and update the distance
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				// Read the data from the result row
				int id = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)] intValue];
				CLLocationDegrees meetingLat = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)] doubleValue];
				CLLocationDegrees meetingLng = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)] doubleValue];
				CLLocation* meetingLocation  = [[CLLocation alloc] initWithLatitude:meetingLat longitude:meetingLng];
				CLLocationDistance distance  = [location distanceFromLocation:meetingLocation];
				[meetingLocation release];
                
				NSString* sql2 = [NSString stringWithFormat:@"UPDATE location SET distance = %f, from_location = '%f,%f' WHERE id = %d", 
								  distance, 
								  location.coordinate.latitude, location.coordinate.longitude,
								  id];
				
				sqlite3_stmt *compiledStatement2;
				if ((ret = sqlite3_prepare_v2(database, [sql2 cStringUsingEncoding:NSASCIIStringEncoding], -1, &compiledStatement2, NULL)) == SQLITE_OK) {
					sqlite3_step(compiledStatement2); 
				} else {
					// XXX: pass in error message in last parameter
					NSLog(@"Problem updating distance (%f) for location with id %d.", distance, id);
				}
				
				//NSLog(@"Calculating id %d lat %f lng %f distance %@", id, meetingLat, meetingLng, [Utilities metersToNiceString:distance]);
                
			}
		}
        if (ret != 0) 
        {
            NSLog(@"error with sqlite %s", sqlite3_errmsg(database));
        }
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);
	}
    if (ret != 0) 
    {
        NSLog(@"error with sqlite %s", sqlite3_errmsg(database));
    }
    
}


-(NSArray *)getHomeStops
{
    NSMutableArray* trains = [[[NSMutableArray alloc] init] autorelease];
	
	int ret = 0;
	
	NSMutableDictionary* trainDict;
	
	
	// Setup the database object
	sqlite3 *database;
    NSString *sql = [self getSql:@"homeTripsSql"];
    NSString *filler = @"%s";
    NSArray *days = [DataSource getDaysForDay];
    sql = [NSString stringWithFormat:sql, filler,filler,
           [[days objectAtIndex:0] intValue], 
           [[days objectAtIndex:1] intValue], 
           [[days objectAtIndex:2] intValue], 
           [[days objectAtIndex:3] intValue], 
           [[days objectAtIndex:4] intValue], 
           [[days objectAtIndex:5] intValue], 
           [[days objectAtIndex:6] intValue],filler,filler, 
           [[days objectAtIndex:0] intValue], 
           [[days objectAtIndex:1] intValue], 
           [[days objectAtIndex:2] intValue], 
           [[days objectAtIndex:3] intValue], 
           [[days objectAtIndex:4] intValue], 
           [[days objectAtIndex:5] intValue], 
           [[days objectAtIndex:6] intValue] ];
    NSLog(@"Our formatted string is %@", sql);
	// Open the database from the users filessytem
	if((ret = sqlite3_open([databasePath UTF8String], &database)) == SQLITE_OK) 
    {
        sqlite3_stmt *compiledStatement;
		if ((ret = sqlite3_prepare_v2(database, [sql cStringUsingEncoding:NSASCIIStringEncoding], -1, &compiledStatement, NULL)) == SQLITE_OK)
        {
            // Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
            {
                // Read the data from the result row
                trainDict = [[NSMutableDictionary alloc] init];
                
                NSString *trip_id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *service_id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *departs = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSString *arrives = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                NSString *day = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                NSString *work =[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)]; 
                NSString *home =[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)]; 
                NSString* to_lat = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                NSString* to_lon = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                NSString* from_lat = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
                NSString* from_lon = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)];
                NSString* route_long_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)];
                NSString* agency_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 13)];
                NSString* trip_headsign = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 14)];
                [trainDict setValue:trip_id forKey:@"trip_id"];
                [trainDict setValue:service_id forKey:@"service_id"];
                [trainDict setValue:departs forKey:@"departs"];
                [trainDict setValue:arrives forKey:@"arrives"];
                [trainDict setValue:day forKey:@"day"];
                [trainDict setValue:work forKey:@"work"];
                [trainDict setValue:home forKey:@"home"];
                [trainDict setValue:to_lat forKey:@"to_lat"];
                [trainDict setValue:to_lon forKey:@"to_lon"];
                [trainDict setValue:from_lat forKey:@"from_lat"];
                [trainDict setValue:from_lon forKey:@"from_lon"];
                [trainDict setValue:route_long_name forKey:@"route_long_name"];
                [trainDict setValue:agency_name forKey:@"agency_name"];
                [trainDict setValue:trip_headsign forKey:@"trip_headsign"];
                [trains addObject:trainDict];
                [trainDict release];
                
            }
        }
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);
    }
    if (ret != 0) 
    {
        NSLog(@"error with sqlite %s", sqlite3_errmsg(database));
    }
    return (trains);
}

-(NSArray *)getWorkStops
{
    NSMutableArray* trains = [[[NSMutableArray alloc] init] autorelease];
	
	int ret = 0;
	
	NSMutableDictionary* trainDict;
	
	
	// Setup the database object
	sqlite3 *database;
    NSString *sql = [self getSql:@"workTripsSql"];
    NSString *filler = @"%s";
    NSArray *days = [DataSource getDaysForDay];
    sql = [NSString stringWithFormat:sql, filler, filler,
           [[days objectAtIndex:0] intValue], 
           [[days objectAtIndex:1] intValue], 
           [[days objectAtIndex:2] intValue], 
           [[days objectAtIndex:3] intValue], 
           [[days objectAtIndex:4] intValue], 
           [[days objectAtIndex:5] intValue], 
           [[days objectAtIndex:6] intValue], filler, filler,
           [[days objectAtIndex:0] intValue], 
           [[days objectAtIndex:1] intValue], 
           [[days objectAtIndex:2] intValue], 
           [[days objectAtIndex:3] intValue], 
           [[days objectAtIndex:4] intValue], 
           [[days objectAtIndex:5] intValue], 
           [[days objectAtIndex:6] intValue]];
    NSLog(@"Our formatted string is %@", sql);
	// Open the database from the users filessytem
	if((ret = sqlite3_open([databasePath UTF8String], &database)) == SQLITE_OK) 
    {
        sqlite3_stmt *compiledStatement;
		if ((ret = sqlite3_prepare_v2(database, [sql cStringUsingEncoding:NSASCIIStringEncoding], -1, &compiledStatement, NULL)) == SQLITE_OK)
        {
            // Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
            {
                // Read the data from the result row
                trainDict = [[NSMutableDictionary alloc] init];
                
                NSString *trip_id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *service_id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *departs = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSString *arrives = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                NSString *day = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                NSString *work =[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)]; 
                NSString *home =[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)]; 
                NSString* to_lat = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                NSString* to_lon = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                NSString* from_lat = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
                NSString* from_lon = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)];
                NSString* route_long_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)];
                NSString* agency_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 13)];
                NSString* trip_headsign = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 14)];
                [trainDict setValue:trip_id forKey:@"trip_id"];
                [trainDict setValue:service_id forKey:@"service_id"];
                [trainDict setValue:departs forKey:@"departs"];
                [trainDict setValue:arrives forKey:@"arrives"];
                [trainDict setValue:day forKey:@"day"];
                [trainDict setValue:work forKey:@"work"];
                [trainDict setValue:home forKey:@"home"];
                [trainDict setValue:to_lat forKey:@"to_lat"];
                [trainDict setValue:to_lon forKey:@"to_lon"];
                [trainDict setValue:from_lat forKey:@"from_lat"];
                [trainDict setValue:from_lon forKey:@"from_lon"];
                [trainDict setValue:route_long_name forKey:@"route_long_name"];
                [trainDict setValue:agency_name forKey:@"agency_name"];
                [trainDict setValue:trip_headsign forKey:@"trip_headsign"];
                [trains addObject:trainDict];
                [trainDict release];
                
            }
        }
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);
    }
    if (ret != 0) 
    {
        NSLog(@"error with sqlite %s", sqlite3_errmsg(database));
    }
    return (trains);
}


#pragma mark -
#pragma mark Database methods

-(NSArray*) getNextTrainsFrom: (int)fromStopId to: (int)toStopId withDirection: (int)directionId onDay: (NSString*)day afterHour: (int)hour {
    
	
	NSMutableArray* trains = [[[NSMutableArray alloc] init] autorelease];
	
	int ret = 0;
	
	NSMutableDictionary* trainDict;
	
	
	// Setup the database object
	sqlite3 *database;	
	// Open the database from the users filessytem
	if((ret = sqlite3_open([databasePath UTF8String], &database)) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = "select t.route_id, (r.route_long_name || ' Line') as route_long_name, r.route_type, r.route_color, r.route_text_color, "
        "t.service_id, st_to.trip_id,  "
        "st_from.departure_time, st_to.arrival_time, "
        "(strftime('%s', st_to.arrival_time) - strftime('%s',st_from.departure_time)) /  60 as trip_time , "
        "t.trip_headsign, t.trip_short_name, "
        "s_to.stop_lat as to_lat, s_to.stop_lon as to_lon, "
        "s_from.stop_lat as from_lat, s_from.stop_lon as from_lon, "
        "min(s_from.wheelchair_accessible, s_to.wheelchair_accessible, t.wheelchair_boarding) as wheelchair_accessible, "
        "s_to.stop_name as to_name, s_from.stop_name as from_name, "
        "(select agency_name from agency limit 1) as agency_name "
        "from stop_times st_to "
        "inner join trips t on t.trip_id = st_to.trip_id "
        "inner join stop_times st_from on (t.trip_id = st_from.trip_id and st_from.stop_id = 1) "
        "inner join routes r on r.route_id = t.route_id  "
        "inner join stops s_to on st_to.stop_id = s_to.stop_id  "
        "inner join stops s_from on st_from.stop_id = s_from.stop_id "
        "where st_to.stop_id = 140 and st_to.trip_id in "
        "(select trip_id from trips where direction_id = 0 and service_id in (select service_id from calendar where monday = 1) "
        " group by trip_id) "
        "order by st_from.departure_time asc";
        
        // st.departure_time > "15:00:00"
        
        sqlite3_stmt *compiledStatement;
		if((ret = sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL)) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                // Read the data from the result row
                trainDict = [[NSMutableDictionary alloc] init];
                NSString* route_id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString* route_long_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                //NSString* route_type = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSString* route_color = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                NSString* route_text_color = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                //NSString* service_id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                //NSString* trip_id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                NSString* departure_time = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                NSString* arrival_time = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                NSString* trip_time = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
                NSString* trip_headsign = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)];
                NSString* trip_short_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)];
                NSString* to_lat = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 12)];
                NSString* to_lon = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 13)];
                NSString* from_lat = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 14)];
                NSString* from_lon = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 15)];
                //NSString* wheelchair_accessible = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 16)];
                NSString* to_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 17)];
                NSString* from_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 18)];
                NSString* agency_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 19)];
                [trainDict setValue:route_id forKey:@"route_id"];
                [trainDict setValue:route_long_name forKey:@"route_long_name"];
                [trainDict setValue:route_color forKey:@"route_color"];
                [trainDict setValue:route_text_color forKey:@"route_text_color"];
                [trainDict setValue:departure_time forKey:@"departure_time"];
                [trainDict setValue:arrival_time forKey:@"arrival_time"];
                [trainDict setValue:trip_time forKey:@"trip_time"];
                [trainDict setValue:trip_headsign forKey:@"trip_headsign"];
                [trainDict setValue:trip_short_name forKey:@"trip_short_name"];
                [trainDict setValue:to_lat forKey:@"to_lat"];
                [trainDict setValue:to_lon forKey:@"to_lon"];
                [trainDict setValue:from_lat forKey:@"from_lat"];
                [trainDict setValue:from_lon forKey:@"from_lon"];
                [trainDict setValue:to_name forKey:@"to_name"];
                [trainDict setValue:from_name forKey:@"from_name"];
                [trainDict setValue:agency_name forKey:@"agency_name"];
                [trains addObject:trainDict];
                [trainDict release];		
				
			}
		} else {
			NSLog(@"Problem preparing SQL statement.   Returned %d for database at %@.",ret, databasePath);
		}
        if (ret != 0) 
        {
            NSLog(@"error with sqlite %s", sqlite3_errmsg(database));
        }
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);
		
	} else {
		NSLog(@"Problem opening the database at %@.", databasePath);	
	}
	if (ret != 0) 
    {
        NSLog(@"error with sqlite %s", sqlite3_errmsg(database));
    }
	return (trains);
}






-(NSArray*) getRoutes {
	
	//locationIndex = 0;
	
	NSMutableArray* routes = [[[NSMutableArray alloc] init] autorelease];
	
	int ret = 0;
	
	NSMutableDictionary* routeDict;
	
	
	// Setup the database object
	sqlite3 *database;	
	// Open the database from the users filessytem
	if((ret = sqlite3_open([databasePath UTF8String], &database)) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = "select route_id, route_long_name, route_desc, "
        "route_type, route_color, route_text_color, (select agency_name from agency limit 1) as agency_name "
        "from routes order by route_long_name asc";
		sqlite3_stmt *compiledStatement;
		if((ret = sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL)) == SQLITE_OK) {
            // Loop through the results and add them to the feeds array
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                // Read the data from the result row
                routeDict = [[NSMutableDictionary alloc] init];
                NSString* route_id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString* route_long_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString* route_desc = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                //NSString* route_type = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                NSString* route_color = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                NSString* route_text_color = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                NSString* agency_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                
                [routeDict setValue:route_id forKey:@"route_id"];
                [routeDict setValue:route_long_name forKey:@"route_long_name"];
                [routeDict setValue:route_desc forKey:@"route_desc"];
                [routeDict setValue:agency_name forKey:@"agency_name"];
                [routeDict setValue:route_color forKey:@"route_color"];
                [routeDict setValue:route_text_color forKey:@"route_text_color"];
                [routes addObject:routeDict];
                [routeDict release];		
				
            }
		} else {
			NSLog(@"Problem preparing SQL statement.   Returned %d for database at %@.",ret, databasePath);
		}
        if (ret != 0) 
        {
            NSLog(@"error with sqlite %s", sqlite3_errmsg(database));
        }
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);
		
	} else {
		NSLog(@"Problem opening the database at %@.", databasePath);	
	}
	if (ret != 0) 
    {
        NSLog(@"error with sqlite %s", sqlite3_errmsg(database));
    }
	return (routes);
}


-(NSArray*) getRouteStops:(NSString*) route_id {
	
	//locationIndex = 0;
	
	NSMutableArray* stops = [[[NSMutableArray alloc] init] autorelease];
	
	int ret = 0;
	
	NSMutableDictionary* stopDict;
	
	
	// Setup the database object
	sqlite3 *database;	
	// Open the database from the users filessytem
	if((ret = sqlite3_open([databasePath UTF8String], &database)) == SQLITE_OK) {
		NSString* sql = [NSString stringWithFormat:@"select st.stop_id, max(st.stop_sequence) as stop_sequence, "
                         "s.stop_name, s.stop_desc, s.stop_lat, s.stop_lon "
                         "from stop_times st "
                         "inner join stops s on s.stop_id = st.stop_id "
                         "where trip_id in (select trip_id from trips where route_id = %@ and direction_id = 0) "
                         "group by st.stop_id order by stop_sequence asc",
                         route_id];
        
        //NSLog(@"sql %@", sql);
        
        sqlite3_stmt *compiledStatement;
		if((ret = sqlite3_prepare_v2(database, [sql cStringUsingEncoding:NSASCIIStringEncoding], -1, &compiledStatement, NULL)) == SQLITE_OK) {
            // Loop through the results and add them to the feeds array
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                // Read the data from the result row
                stopDict = [[NSMutableDictionary alloc] init];
                NSString* stop_id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString* stop_sequence = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString* stop_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSString* stop_desc = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                NSString* stop_lat = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                NSString* stop_lon = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                
                [stopDict setValue:stop_id forKey:@"stop_id"];
                [stopDict setValue:stop_sequence forKey:@"stop_sequence"];
                [stopDict setValue:stop_name forKey:@"stop_name"];
                [stopDict setValue:stop_desc forKey:@"stop_desc"];
                [stopDict setValue:stop_lat forKey:@"stop_lat"];
                [stopDict setValue:stop_lon forKey:@"stop_lon"];
                [stops addObject:stopDict];
                [stopDict release];		
				
            }
		} else {
			NSLog(@"Problem preparing SQL statement.   Returned %d for database at %@.",ret, databasePath);
		}
        
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);
		
	} else {
		NSLog(@"Problem opening the database at %@.", databasePath);	
	}
	if (ret != 0) 
    {
        NSLog(@"error with sqlite %s", sqlite3_errmsg(database));
    }
	return (stops);
}


///
/// Returns schema version.
///
-(NSString*) getSchemaVersion {
	// Setup the database object
	sqlite3 *database;
	
	NSString* version = @"unknown";
	
	int ret = 0;
	
	// Open the database from the users filesystem
	if((ret = sqlite3_open([databasePath UTF8String], &database)) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = "PRAGMA schema_version";
		sqlite3_stmt *compiledStatement;
		if((ret = sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL)) == SQLITE_OK) {
			// Loop through the results (should only be one) and set slogan.
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				version = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
				break;
			}
		} else {
			NSLog(@"Problem preparing SQL statement.   Returned %d for database at %@.",ret, databasePath);
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);
		
	} else {
		NSLog(@"Problem opening the database at %@.", databasePath);	
	}
	if (ret != 0) 
    {
        NSLog(@"error with sqlite %s", sqlite3_errmsg(database));
    }
	return (version);
}




// Checks if a newer version of the SQLite database is online.  If so download it.
-(void) updateDatabaseFromWebIfNewer {
	
	// get
	sqlite3 *database;
	int ret = 0;
	NSString* localDBLastModified = nil;
	
	// Open the database from the users filesystem
	if((ret = sqlite3_open([databasePath UTF8String], &database)) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = "select max(last_updated) as last_updated from (select max(last_updated) as last_updated from location union select max(last_updated) as last_updated from meeting) as t";
		sqlite3_stmt *compiledStatement;
		if((ret = sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL)) == SQLITE_OK) {
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				localDBLastModified = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
				break;
			}
		} else {
			NSLog(@"Problem preparing SQL statement.   Returned %d for database at %@.",ret, databasePath);
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);
	} else {
		NSLog(@"Problem opening the database at %@.", databasePath);	
	}
	if (ret != 0) 
    {
        NSLog(@"error with sqlite %s", sqlite3_errmsg(database));
    }
	
	NSURL *url = [[NSURL alloc] initWithString:WEB_SERVICE_DB_LAST_MODIFIED];
	NSString* webDBLastModified = [[NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil] 
								   stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	[url release];
	
	//[NSString stringWithContentsOfURL:WEB_SERVICE_DB_LAST_MODIFIED encoding:NSASCIIStringEncoding error:nil];
	
	
	//if ((localDBLastModified == nil) || ([localDBLastModified isEqualToString:webDBLastModified] == NO)) {
	if ([localDBLastModified isEqualToString:webDBLastModified] == FALSE) {
		NSLog(@"Updating local database which was last modified %@ with database from web which was modified on %@.", 
              localDBLastModified, webDBLastModified);
		
		// newer database file exists on the internet, so copy to local file system
		NSData* sqliteData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:WEB_SERVICE_DB_FILE]];
        
		//[self performSelectorOnMainThread:@selector(displayImage:) withObject:image waitUntilDone:NO];
        
		if ([sqliteData length] > 100) {
			[sqliteData writeToFile:databasePath atomically:YES];
		}
		[sqliteData release];
	}
	
}




///
/// Given time (01:20:00) returns time string in nice format (1:20 AM).
///
+ (NSString *)timeToNiceString:(NSString *)time{
	NSString *result = @"";
    NSArray *parts = [time componentsSeparatedByString:@":"];
    if ([parts count] >= 2) {
        NSString *meridian = @"AM";
        NSInteger hours = [[parts objectAtIndex:0] integerValue];
        NSInteger minutes = [[parts objectAtIndex:1] integerValue];
        hours = hours % 24;
        if (hours >= 12) {
            meridian = @"PM";
            hours = hours % 12;
        }
        if (hours == 0) {
            hours = 12;
        }
        result = [NSString stringWithFormat:@"%d:%02d %@", hours, minutes, meridian];
    }
    
	return (result);
}

+ (NSString *)calculateDuration:(NSString *)startOn end:(NSString *)endOn {
    
    NSArray *parts = [startOn componentsSeparatedByString:@":"];
    NSInteger startMinutes;
    NSInteger endMinutes;
    if ([parts count] >= 2) {
        NSInteger hours   = [[parts objectAtIndex:0] integerValue];
        NSInteger minutes = [[parts objectAtIndex:1] integerValue];
        startMinutes = (hours*60) + minutes;
    }
    parts = [endOn componentsSeparatedByString:@":"];
    if ([parts count] >= 2) {
        NSInteger hours   = [[parts objectAtIndex:0] integerValue];
        NSInteger minutes = [[parts objectAtIndex:1] integerValue];
        endMinutes = (hours*60) + minutes;
    }
    endMinutes -= startMinutes;
    return [DataSource minutesToNiceString:endMinutes];

}

///
/// Given time in minutes returns time string in nice format (e.g. 1 hour 10 minutes).
///
+ (NSString *)minutesToNiceString:(NSInteger)minutes {
	NSString *result = nil;
	
    NSInteger hours = minutes / 60;
    NSInteger remainingMinutes = minutes % 60;
    NSString *space = @"";
    if (hours > 1) {
        result = [NSString stringWithFormat:@"%d hours", hours];
        space = @" ";
    } else if (hours == 1) {
        result = [NSString stringWithFormat:@"1 hour"];
        space = @" ";
    }
    
    
    if (remainingMinutes > 1) {
        result = [NSString stringWithFormat:@"%@%@%d minutes", result, space, remainingMinutes];
    } else if (remainingMinutes == 1) {
        result = [NSString stringWithFormat:@"%@%@1 minute", result, space];
        
    }
    
	return (result);
}



+ (NSString *)distancesFromLat:(double)fromLat andLon:(double)fromLon toLat:(double)toLat andLon:(double)toLon {
    
    NSString *result;
    
    CLLocation* fromLocation = [[CLLocation alloc] initWithLatitude:fromLat longitude:fromLon];
    CLLocation* toLocation = [[CLLocation alloc] initWithLatitude:toLat longitude:toLon];
    CLLocationDistance distance = [toLocation distanceFromLocation:fromLocation];
    
    [fromLocation release];
    [toLocation release];
    
    double feet = distance * 3.2808399;
    
    NSLog(@"feet: %f, from: %f %f, to: %f %f", feet, fromLat, fromLon, toLat, toLon);
    
    if (feet <= 100) {
		result = [NSString stringWithFormat:@"100 feet"];
	} else if (feet <= 1000) {
		result = [NSString stringWithFormat:@"%1.0f feet", feet];
	} else {
		double miles = feet / 5280;
		result = [NSString stringWithFormat:@"%1.1f miles", miles];
	}
	return (result);
    
}

/*
 the database definition uses a column identifier to designate if a route is running on 
 a given day e.g. where tuesday = 1 vs where tuesday = 0 which is somewhat a pain because
 it requires us to run a block where clause where we pass in a 0/1 value for each day
 of the week. This function encapsulates that logic returning back an array of 7 integers
 of either 0 or 1 starting at 0 for Sunday - 6 for Saturday.
 */
+(NSArray *)getDays {
    NSMutableArray* days = [[[NSMutableArray alloc] init] autorelease];
    return (NSArray *)(days);
}



+(NSArray *)getDaysForDay {
    NSMutableArray* days = [[[NSMutableArray alloc] init] autorelease];
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    int weekday = [comps weekday];
    for (int index = 0; index < 7; index=index+1) {
        if ((weekday-1) == index) {
            [days addObject:[NSNumber numberWithInt:1]];
        } else {
            [days addObject:[NSNumber numberWithInt:0]];     
        }
    }
    return (NSArray *)(days);
}




#pragma mark -
#pragma mark class instance methods

#pragma mark -
#pragma mark Singleton methods

+ (DataSource*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil) {
			sharedInstance = [[DataSource alloc] init];
            
		}
    }
    return sharedInstance;
}

-(DataSource*) init {
    self = [super init];
	
    if ( self ) {
        
		queue = [[NSOperationQueue alloc] init];
		// Create instance of LocationManager and set self as the delegate
		locationManager = [[CLLocationManager alloc] init];
		locationManager.delegate = self;
		
		//[locationManager startMonitoringSignificantLocationChanges];
		[locationManager startUpdatingLocation];
		
        ///Users/russellsimpkins/Library/Application Support/iPhone Simulator/4.3.2/Applications/BC4E35CD-6AF2-4CA1-9508-98919B750EA2/Documents/mta.sqlite
		// load data from the database
		databaseName = @"mta.sqlite";
		// Get the path to the documents directory and append the databaseName
		NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDir = [documentPaths objectAtIndex:0];
		databasePath = [[documentsDir stringByAppendingPathComponent:databaseName] retain];
		NSLog(@"databasePath = %@",databasePath);
        
		// Use File Manager to check if the SQL database has already been saved to the user's phone, if not then copy it over from bundle
		NSFileManager *fileManager = [[NSFileManager alloc] init];
		BOOL success = [fileManager fileExistsAtPath:databasePath];
		if (success == false) {
			// Get the path to the database in the application package
			NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
			
			NSData* fileData = [fileManager contentsAtPath:databasePathFromApp];
			
			// Copy the database from the package to the users filesystem
			[fileData writeToFile:databasePath atomically:YES];
            
			//[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
		}
		[fileManager release];
        
        
    }
	
    return self;
}

// called by App Delegate when application becomes active.
- (void)applicationDidBecomeActive {
	
    
	
	
	//[locationManager startMonitoringSignificantLocationChanges];
	[locationManager startUpdatingLocation];
	
	/*	
     NSInvocationOperation *operation = [[NSInvocationOperation alloc] 
     initWithTarget:self
     selector:@selector(updateDatabaseFromWebIfNewer) 
     object:nil];
     [queue addOperation:operation]; 
     [operation release];
     */
}

// called by App Delegate when application enters background.
- (void)applicationDidEnterBackground {
    
	// XXX: stop location manager
	if (locationManager != nil) {
		//[locationManager stopMonitoringSignificantLocationChanges];
		[locationManager stopUpdatingLocation];
	}
}


+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

#pragma mark CLLocationManager Methods
// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	NSLog(@"locationManager:didUpdateToLocation: %f, %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
	if (currentLocation != newLocation) {
		if (currentLocation != nil) {
			[currentLocation release];
		}
		currentLocation = newLocation;	
		[currentLocation retain];
	}
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"locationManager:didFailWithError: %@", [error description]);
}



@end
