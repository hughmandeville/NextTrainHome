//
//  GoHomeView.m
//  NextTrainHome
//
//  Created by Hubert Mandeville on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GoHomeView.h"
#import "StopTimeCellView.h"
#import "DataSource.h"

@implementation GoHomeView
@synthesize homeTableView;

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
    
    
    
}

-(void)loadData
{
    DataSource *dataSource = [DataSource sharedInstance];
    trains = [[dataSource getHomeStops] retain];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"will appear called");
    [self loadData];
    [homeTableView reloadData];
}

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
    return [trains count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"StopTimeCell";
	StopTimeCellView *cell = (StopTimeCellView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"StopTimeCellView" owner:nil options:nil];
		for (id currentObject in topLevelObjects) {
			if ([currentObject isKindOfClass:[UITableViewCell class]]) {
				cell = (StopTimeCellView *)currentObject;
				break;
			}
		}
	}
    
    NSDictionary *train = [trains objectAtIndex:indexPath.row];
    
    
    cell.fromTimeLabel.text = [DataSource timeToNiceString:[train objectForKey:@"departs"]];
    cell.toTimeLabel.text   = [DataSource timeToNiceString:[train objectForKey:@"arrives"]];
    cell.fromStopLabel.text = [train objectForKey:@"work"];
    cell.toStopLabel.text   = [train objectForKey:@"home"];
    cell.distanceLabel.text = [DataSource distancesFromLat:[[train objectForKey:@"from_lat"] doubleValue]
                                                    andLon:[[train objectForKey:@"from_lon"] doubleValue] 
                                                     toLat:[[train objectForKey:@"to_lat"] doubleValue]  
                                                    andLon:[[train objectForKey:@"to_lon"] doubleValue]];
    cell.routeLabel.text    = [train objectForKey:@"route_long_name"];
    cell.agencyLabel.text   = [train objectForKey:@"agency_name"];
    cell.headsignLabel.text = [train objectForKey:@"trip_headsign"];
    cell.durationLabel.text = [DataSource calculateDuration:[train objectForKey:@"departs"] end:[train objectForKey:@"arrives"]];
    /*
    NSString *colorStr = [NSString stringWithFormat:@"0x%@ff", [train objectForKey:@"route_color"]];
    unsigned int colorValue;
    NSScanner *scanner = [NSScanner scannerWithString:colorStr];
    [scanner scanHexInt:&colorValue];
    cell.routeLabel.textColor = HEXCOLOR(colorValue);
     */
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
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
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

