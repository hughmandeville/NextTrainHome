//
//  StopsView.h
//  NextTrainHome
//
//  Created by Hubert Mandeville on 3/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StopsView : UITableViewController {
 

    NSString *route_id;
    NSArray *stops;
    
}

@property (nonatomic, retain) NSString *route_id;

@end
