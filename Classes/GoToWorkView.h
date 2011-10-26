//
//  GoToWorkView.h
//  NextTrainHome
//
//  Created by Hubert Mandeville on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GoToWorkView : UITableViewController {
    NSArray *trains;
    UITableView *workTableView;
}
@property (nonatomic,retain) IBOutlet UITableView *workTableView;
-(void)loadData;
@end
