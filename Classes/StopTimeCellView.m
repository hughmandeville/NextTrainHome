//
//  StopTimeCellView.m
//  NextTrainHome
//
//  Created by Hubert Mandeville on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StopTimeCellView.h"


@implementation StopTimeCellView

@synthesize agencyLabel;
@synthesize routeLabel;
@synthesize fromStopLabel;
@synthesize fromTimeLabel;
@synthesize toStopLabel;
@synthesize toTimeLabel;
@synthesize headsignLabel;
@synthesize durationLabel;
@synthesize distanceLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
	
	[agencyLabel release];
    [headsignLabel release];
	[routeLabel release];
	[fromStopLabel release];
	[fromTimeLabel release];
	[toStopLabel release];
	[toTimeLabel release];
    [distanceLabel release];
	[durationLabel release];
	
    [super dealloc];
}


@end
