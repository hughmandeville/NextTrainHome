//
//  RouteCellView.m
//  NextTrainHome
//
//  Created by Hubert Mandeville on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RouteCellView.h"


@implementation RouteCellView

@synthesize routeLabel;
@synthesize routeBarLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [routeLabel release];
    [routeBarLabel release];
    [super dealloc];
}

@end
