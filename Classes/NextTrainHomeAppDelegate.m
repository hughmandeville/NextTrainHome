//
//  NextTrainHomeAppDelegate.m
//  NextTrainHome
//
//  Created by Hubert Mandeville on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NextTrainHomeAppDelegate.h"

@implementation NextTrainHomeAppDelegate

@synthesize window;
@synthesize tabController;

-(IBAction)refreshView:(id)sender
{
    NSLog(@"refresh views called.");
    /*
    NSArray *views = [[self tabController] viewControllers];
    for (int index = 0; index < [views count]; ++index) {
        UIViewController *aview = [views objectAtIndex:index];
    }*/
}
#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    
	[window addSubview:tabController.view];
	
    [self.window makeKeyAndVisible];
    

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[tabController release];
    [window release];
    [super dealloc];
}


@end
