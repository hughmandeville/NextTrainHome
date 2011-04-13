//
//  RouteCellView.h
//  NextTrainHome
//
//  Created by Hubert Mandeville on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RouteCellView : UITableViewCell {
 
    IBOutlet UILabel *routeLabel;
    IBOutlet UILabel *routeBarLabel;
    
}

@property (nonatomic, retain) IBOutlet UILabel *routeLabel;
@property (nonatomic, retain) IBOutlet UILabel *routeBarLabel;

@end
