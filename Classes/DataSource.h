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

#define HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 \
green:((c>>16)&0xFF)/255.0 \
blue:((c>>8)&0xFF)/255.0 \
alpha:((c)&0xFF)/255.0];



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
-(void) applicationDidBecomeActive;
-(void) applicationDidEnterBackground;
-(NSArray *) getNextTrainsFrom: (int)fromStopId to: (int)toStopId withDirection: (int)directionId onDay: (NSString *)day afterHour: (int)hour;
-(NSArray *)getRoutes;
-(NSArray *)getRouteStops:(NSString*) route_id;
-(NSArray *)getAllStops;
-(void)setHomeStop:(NSNumber *)homeStopId;
-(void)setWorkStop:(NSNumber *)workStopId;
-(NSDictionary *)getHomeStop;
-(NSDictionary *)getWorkStop;
-(NSString *)getSql:(NSString *)name;
-(void) calculateStopsDistancesFrom:(CLLocation *)location;
-(NSNumber *)getHomeStopId;
-(NSNumber *)getWorkStopId;
-(NSArray *)getHomeStops;
-(NSArray *)getWorkStops;

+ (NSString *)timeToNiceString:(NSString*)time;
+ (NSString *)minutesToNiceString:(NSInteger)minutes;
+ (NSString *)calculateDuration:(NSString *)startOn end:(NSString *)endOn;
+ (NSString *)distancesFromLat:(double)fromLat andLon:(double)fromLon toLat:(double)toLat andLon:(double)toLon;
+ (NSArray *)getDays;
+(NSArray *)getDaysForDay;

@end
