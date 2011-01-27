//
//  HTTPServerAppDelegate.h
//  HTTPServer
//
//  Created by Your Name on 11/01/27.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTPServerController.h"

@interface HTTPServerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window_;
	HTTPServerController *httpServerController_;
}

@end

