//
//  GoHomeView.h
//  NextTrainHome
//
//  Created by Hubert Mandeville on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GoHomeView : UITableViewController {
    NSArray *trains;
    UITableView *homeTableView;
}
-(void)loadData;

@property (nonatomic,retain) IBOutlet UITableView *homeTableView;
@end
