//
//  SettingsView.h
//  NextTrainHome
//
//  Created by Hubert Mandeville on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectHomeView.h"

@interface SettingsView : UIViewController <SelectHomeViewDelegate> {
    UIButton *homeStation;
    UIButton *workStation;

    BOOL isHome;
}

-(IBAction)pickHome:(id)sender;
-(IBAction)pickWork:(id)sender;
-(BOOL)isHome;
-(void)isHome:(BOOL)setHome;
@property (assign) IBOutlet UIButton *homeStation;
@property (assign) IBOutlet UIButton *workStation;


@end
