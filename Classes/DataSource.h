//
//  DataSource.h
//  
//  Contains methods for getting meeting location and other information from the SQLite database. 
//
//  Created by Hubert Mandeville on 11/6/10.
//  Copyright 2011 Soul Doubt Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import <CoreLocation/CoreLocation.h>

@interface DataSource : NSObject
<CLLocationManagerDelegate> {
	
	NSString* databaseName;
	NSString* databasePath;

	CLLocationManager *locationManager;
	CLLocation *currentLocation;
	bool updateLocation;
	
	NSOperationQueue *queue; 
}


@property (retain) CLLocationManager *locationManager;
@property (retain) CLLocation *currentLocation;  // don't make nonatomic because updated in thread


+ (DataSource*)sharedInstance;

-(void) updateDatabaseFromWebIfNewer;


- (void)applicationDidBecomeActive;
- (void)applicationDidEnterBackground;

-(NSArray*) getRoutes;
-(NSArray*) getRouteStops:(NSString*) route_id;


-(void) calculateStopsDistancesFrom:(CLLocation *)location;

+ (NSString *)metersToNiceString:(CLLocationDistance)distance;


@end
