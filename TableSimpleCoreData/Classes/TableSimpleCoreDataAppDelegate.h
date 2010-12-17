//
//  TableSimpleCoreDataAppDelegate.h
//  TableSimpleCoreData
//
//  Created by Your Name on 10/12/17.
//  Copyright 2010 Your Org Name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleCoreData.h"
#import "RootViewController.h"

@interface TableSimpleCoreDataAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window_;
	UINavigationController *navigationController_;
	RootViewController *rootViewController_;
	
	
	SimpleCoreData *simpleCoreData_;
}

@end

