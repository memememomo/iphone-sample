//
//  SearchTableWithSimpleCoreDataAppDelegate.h
//  SearchTableWithSimpleCoreData
//
//  Created by Your Name on 10/12/18.
//  Copyright 2010 Your Org Name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleCoreData.h"
#import "RootViewController.h"

@interface SearchTableWithSimpleCoreDataAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window_;
	SimpleCoreData *simpleCoreData_;
	RootViewController *rootViewController_;
	UINavigationController *navigationController_;
}

@end

