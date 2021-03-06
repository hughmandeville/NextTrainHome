//
//  StopTimeCellView.h
//  NextTrainHome
//
//  Created by Hubert Mandeville on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StopTimeCellView : UITableViewCell {
	IBOutlet UILabel *agencyLabel;
    IBOutlet UILabel *routeLabel;
	IBOutlet UILabel *fromStopLabel;
	IBOutlet UILabel *fromTimeLabel;
    IBOutlet UILabel *toStopLabel;
	IBOutlet UILabel *toTimeLabel;
	IBOutlet UILabel *durationLabel;
    IBOutlet UILabel *distanceLabel;
    IBOutlet UILabel *headsignLabel;
	
}

@property (nonatomic, retain) IBOutlet UILabel *agencyLabel;
@property (nonatomic, retain) IBOutlet UILabel *routeLabel;
@property (nonatomic, retain) IBOutlet UILabel *fromStopLabel;
@property (nonatomic, retain) IBOutlet UILabel *fromTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *toStopLabel;
@property (nonatomic, retain) IBOutlet UILabel *toTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *durationLabel;
@property (nonatomic, retain) IBOutlet UILabel *distanceLabel;
@property (nonatomic, retain) IBOutlet UILabel *headsignLabel;

@end
