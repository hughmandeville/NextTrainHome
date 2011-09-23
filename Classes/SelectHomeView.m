//
//  SelectHomeView.m
//  NextTrainHome
//
//  Created by Russell Simpkins on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SelectHomeView.h"
#import "DataSource.h"

@implementation SelectHomeView
@synthesize stopPicker,delegate,pageLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setIsHome:(BOOL)isHome
{
    home = isHome;
    
}

- (void)dealloc
{
    [dataForSelector release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"**************** WE LOADED");
    // Do any additional setup after loading the view from its nib.
    DataSource *datasource = [DataSource sharedInstance];

    if (home)
    {
        theStop = [datasource getHomeStop];
    }
    else
    {
        theStop = [datasource getWorkStop];
    }
    /*
     * We need to relelase the dataForSelector, done in the dealloc method.
     */
    dataForSelector = [datasource getAllStops];
    [dataForSelector retain];
    stopIds = [dataForSelector objectAtIndex:0];
    stopNames = [dataForSelector objectAtIndex:1];
    NSInteger row = [stopIds indexOfObject:(id)[theStop objectForKey:@"pk"]];
    [stopPicker selectRow:row inComponent:0 animated:NO];
    NSLog(@"we have this many stops %i and this many names %i", [stopIds count], [stopNames count]);

    if (home) 
    {
        pageLabel.text = @"Pick your home station";
        
    }
    else 
    {
        pageLabel.text = @"Pick your work station";
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - custom methods

-(IBAction)done:(id)sender
{
    NSLog(@"User clicked done button");
}

# pragma mark - pick view data source callbacks
- (NSInteger)numberOfComponentsInPickerView:pickerView 
{
    NSInteger retval = 1;
    return retval;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [stopIds count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [stopNames objectAtIndex:row];
} 

#pragma mark - PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView 
     didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    //homeStop = [stopIds objectAtIndex:row];
    NSLog(@"User selected %@ of pk %@", [stopNames objectAtIndex:row], [stopIds objectAtIndex:row]);
    DataSource *ds = [DataSource sharedInstance];
    if (home)
    {
        NSLog(@"setting home to pk: %@", [stopIds objectAtIndex:row]);
        [ds setHomeStop:[stopIds objectAtIndex:row]];
    } 
    else
    {
        NSLog(@"setting work to pk: %@", [stopIds objectAtIndex:row]);
        [ds setWorkStop:[stopIds objectAtIndex:row]];
    }
    NSLog(@"Send notice to the delegate");
    [delegate homeSelected:home];
}
@end
