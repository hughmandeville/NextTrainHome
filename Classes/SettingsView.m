    //
//  SettingsView.m
//  NextTrainHome
//
//  Created by Hubert Mandeville on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsView.h"
#import "SelectHomeView.h"
#import "DataSource.h"

@implementation SettingsView
@synthesize homeStation,workStation;

-(IBAction)pickHome:(id)sender 
{
    NSLog(@"User clicked to set home location");
    [self isHome:YES];
    SelectHomeView *view = [[SelectHomeView alloc] initWithNibName:@"SelectHomeView" bundle:nil];
    [view setDelegate:self];
    [view setIsHome:YES];
    [[view pageLabel] setText:@"A Select your home station"];

    [self.navigationController pushViewController:view animated:YES];
    [view release];
}

-(IBAction)pickWork:(id)sender 
{
    NSLog(@"User clicked to set work location");
    [self isHome:NO];
    SelectHomeView *view = [[SelectHomeView alloc] initWithNibName:@"SelectHomeView" bundle:nil];
    [view setDelegate:self];
    [view setIsHome:NO];
    [[view pageLabel] setText:@"A Select your work station"];
    [self.navigationController pushViewController:view animated:YES];
    [view release];
}
-(BOOL)isHome 
{
    return self.isHome;
}
-(void)isHome:(BOOL)setHome
{
    isHome = setHome;
}


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    NSLog(@"loadView was called");
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Set nav bar image and background color
    UIImage *image = [UIImage imageNamed: @"NavBarImage.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];	
    self.navigationItem.titleView = imageView;
    [imageView release];
    
    /*
     * Get the id and name for the current station
     */
	DataSource *ds = [DataSource sharedInstance];
    NSDictionary *stopData;
    stopData = [ds getHomeStop];
    NSString *title = [stopData objectForKey:@"name"];
    NSLog(@"Home label will be %@", title);
    [homeStation setTitle:title forState:UIControlStateNormal];
    [homeStation setTitle:title forState:UIControlStateSelected];
    stopData = [ds getWorkStop];
    title = [stopData objectForKey:@"name"];
    NSLog(@"Work label will be %@", title);
    [workStation setTitle:title forState:UIControlStateNormal];
    [workStation setTitle:title forState:UIControlStateSelected];


}

-(void)homeSelected:(BOOL)_isHome
{
    NSLog(@"Recieved notification");
    DataSource *ds = [DataSource sharedInstance];
    NSDictionary *stopData;
    [self isHome:_isHome];
    if (isHome)
    {
        NSLog(@"getting the home stop");
        stopData = [[ds getHomeStop] retain];
        
        [homeStation setTitle:[stopData objectForKey:@"name"] forState:UIControlStateNormal];
        [homeStation setTitle:[stopData objectForKey:@"name"] forState:UIControlStateSelected];
    }
    else
    {
        NSLog(@"getting the work stop ");
        stopData = [[ds getWorkStop] retain];
        [workStation setTitle:[stopData objectForKey:@"name"] forState:UIControlStateNormal];
        [workStation setTitle:[stopData objectForKey:@"name"] forState:UIControlStateSelected];
    }

    [stopData release];
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    NSLog(@"settings unloaded");
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
