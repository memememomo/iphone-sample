//
//  HTTPServer.h
//  UnZipTest
//
//  Created by Your Name on 11/01/27.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTPServer.h"
#import "MyHTTPConnection.h"


@interface HTTPServerController : UIViewController {
	HTTPServer *httpServer_;
	NSDictionary *address_;
	
	IBOutlet UILabel *displayInfo_;
}

- (IBAction)startStopServer:(id)sender;

@end
