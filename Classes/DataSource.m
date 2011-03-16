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
				CLLocation* meetingLocation = [[CLLocation alloc] initWithLatitude:meetingLat longitude:meetingLng];
				
				CLLocationDistance distance = [location distanceFromLocation:meetingLocation];
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
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);
	}
	 
}
																 



#pragma mark -
#pragma mark Database methods

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
		const char *sqlStatement = "select route_id, route_long_name, route_desc, (select agency_name from agency limit 1) as agency_name "
                                   "from route order by route_long_name asc";
		sqlite3_stmt *compiledStatement;
		if((ret = sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL)) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				// Read the data from the result row
				routeDict = [[NSMutableDictionary alloc] init];
				NSString* route_id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
				NSString* route_long_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				NSString* route_desc = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
				NSString* agency_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
				
				[routeDict setValue:route_id forKey:@"route_id"];
				[routeDict setValue:route_long_name forKey:@"route_long_name"];
                [routeDict setValue:route_desc forKey:@"route_desc"];
                [routeDict setValue:agency_name forKey:@"agency_name"];
				[routes addObject:routeDict];
				[routeDict release];		
				
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
                         "from stop_time st "
                         "inner join stop s on s.stop_id = st.stop_id "
                         "where trip_id in (select trip_id from trip where route_id = %@ and trip_headsign like '%%outbound'  group by trip_id) "
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
/// Given distance in meters returns distance string in nice format (e.g. 500 feet, 1.2 miles, ...).
///
+ (NSString *)metersToNiceString:(CLLocationDistance)distance {
	NSString *result;
	double feet = distance * 3.2808399;
	
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
		
	
		// load data from the database
		databaseName = @"nexttrainhome.sqlite";
		// Get the path to the documents directory and append the databaseName
		NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDir = [documentPaths objectAtIndex:0];
		databasePath = [[documentsDir stringByAppendingPathComponent:databaseName] retain];
		

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
	

	
	
	[locationManager startMonitoringSignificantLocationChanges];
	//[locationManager startUpdatingLocation];
	
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
