//
//  RoutesView.m
//  NextTrainHome
//
//  Created by Hubert Mandeville on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RoutesView.h"
#import "StopsView.h"
#import "DataSource.h"
#import "RouteCellView.h"
#import "QuartzCore/QuartzCore.h"

@implementation RoutesView






#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

	// Set nav bar image and background color
    UIImage *image = [UIImage imageNamed: @"NavBarImage.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];	
    self.navigationItem.titleView = imageView;
    [imageView release];
    
    
    DataSource *dataSource = [DataSource sharedInstance];
    
	routes = [[dataSource getRoutes] retain];

}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [routes count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"RouteCell";
	RouteCellView *cell = (RouteCellView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"RouteCellView" owner:nil options:nil];
		for (id currentObject in topLevelObjects) {
			if ([currentObject isKindOfClass:[UITableViewCell class]]) {
				cell = (RouteCellView *)currentObject;
				break;
			}
		}
	}
    
    // Configure the cell...
    NSDictionary *route = [routes objectAtIndex:indexPath.row];
    
    cell.routeBarLabel.text = [route objectForKey:@"route_long_name"];
    cell.routeLabel.text = [route objectForKey:@"route_long_name"];
   
    NSString *colorStr = [NSString stringWithFormat:@"0x%@ff", [route objectForKey:@"route_color"]];
    unsigned int colorValue;
    NSScanner *scanner = [NSScanner scannerWithString:colorStr];
    [scanner scanHexInt:&colorValue];
    //cell.contentView.backgroundColor = HEXCOLOR(colorValue);
    cell.routeBarLabel.backgroundColor = HEXCOLOR(colorValue);
    cell.routeLabel.textColor = HEXCOLOR(colorValue);
    
    colorStr = [NSString stringWithFormat:@"0x%@ff", [route objectForKey:@"route_text_color"]];
    scanner = [NSScanner scannerWithString:colorStr];
    [scanner scanHexInt:&colorValue];
    cell.routeBarLabel.textColor = HEXCOLOR(colorValue);
    

    
    
    
    
    //cell.routeBarLabel.layer.transform = CATransform3DMakeRotation(M_PI, 1.0f, 0.0f, 0.0f);
    
    
    // XXX: figure out how to set the background color, or set colored box next to line name
    // may need to split RGB value from routeColorStr into 3 floats
    //    cell.textLabel.textColor = [UIColor colorWithRed:0.7 green: 0.13 blue:0.13 alpha:1];
    //cell.textLabel.backgroundColor  = [UIColor colorWithRed:0.7 green: 0.13 blue:0.13 alpha:1];
    //cell.textLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    
    
    
    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.    
    NSDictionary *route = [routes objectAtIndex:indexPath.row];
	
    
	StopsView* view;
	view = [[StopsView alloc] initWithNibName:@"StopsView" bundle:nil];
    view.hidesBottomBarWhenPushed = YES;
    view.title = [route objectForKey:@"route_long_name"];
    view.route_id = [route objectForKey:@"route_id"];
	[self.navigationController pushViewController:view animated:YES];
    
    
    
	[view release];	
   
    
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

