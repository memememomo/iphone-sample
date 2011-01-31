//
//  SampleTabBarControllerAppDelegate.h
//  SampleTabBarController
//
//  Created by Your Name on 11/01/31.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SampleTabBarControllerAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, UINavigationControllerDelegate> {
    UIWindow *window_;
	UITabBarController *tabBarController_;
}

@end

