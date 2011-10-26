//
//  NextTrainHomeAppDelegate.h
//  NextTrainHome
//
//  Created by Hubert Mandeville on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NextTrainHomeAppDelegate : NSObject <UIApplicationDelegate> {
    IBOutlet UIWindow *window;
	IBOutlet UITabBarController *tabController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabController;

-(IBAction)refreshView:(id)sender;
@end

