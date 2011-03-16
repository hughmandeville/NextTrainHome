//
//  WebView.h
//  NextTrainHome
//
//  Created by Hubert Mandeville on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebView : UIViewController {
	IBOutlet UIWebView* webView;
	NSString *url;
	NSString *html;
}

@property (nonatomic, retain) IBOutlet UIWebView* webView;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *html;

@end
