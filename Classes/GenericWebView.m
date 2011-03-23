//
//  WebView.m
//  NextTrainHome
//
//  Created by Hubert Mandeville on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GenericWebView.h"


@implementation GenericWebView

@synthesize webView;
@synthesize url;
@synthesize html;

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	webView.scalesPageToFit = TRUE;
    // XXX: zoom in on image.
	NSString* path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	if ((html != nil) && (html.length > 0)) {
		[webView loadHTMLString:html baseURL:baseURL];
	} else {
		// XXX: check file extension
		NSString *filePath = [[NSBundle mainBundle] pathForResource:url ofType:nil];
		NSData *imageData = [NSData dataWithContentsOfFile:filePath];
		[webView loadData:imageData MIMEType:@"image/png" textEncodingName:@"UTF-8" baseURL:baseURL];
		
	}
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[url release];
	[webView release];
	[html release];
    [super dealloc];
}


@end
