//
//  SelectHomeView.h
//  NextTrainHome
//
//  Created by Russell Simpkins on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SelectHomeViewDelegate
-(void)homeSelected:(BOOL)isHome;
@end

@interface SelectHomeView : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource> {
    NSArray *stopIds;
    NSArray *stopNames;
    NSArray *dataForSelector;
    NSDictionary *theStop;
    int currentRow;
    UIPickerView *stopPicker;
    id delegate;
    UILabel *pageLabel;
    BOOL home;
}


-(IBAction)done:(id)sender;
-(void)setIsHome:(BOOL)isHome;
@property (assign) IBOutlet UIPickerView *stopPicker;
@property (nonatomic, retain) id<SelectHomeViewDelegate> delegate;
@property (assign) IBOutlet UILabel *pageLabel;
@end
