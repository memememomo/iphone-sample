//
//  SearchTableWithSimpleCoreDataAppDelegate.m
//  SearchTableWithSimpleCoreData
//
//  Created by Your Name on 10/12/18.
//  Copyright 2010 Your Org Name. All rights reserved.
//

#import "SearchTableWithSimpleCoreDataAppDelegate.h"
#import "RootViewController.h"


@implementation SearchTableWithSimpleCoreDataAppDelegate



#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	
	CGRect frame = [[UIScreen mainScreen] bounds];
	window_ = [[UIWindow alloc] initWithFrame:frame];
	
	simpleCoreData_ = [[SimpleCoreData alloc] init];
	simpleCoreData_.xcdatamodelName = @"SearchTable";
	simpleCoreData_.sqliteName = @"SearchTable";
	
	rootViewController_ = [[RootViewController alloc] init];
	rootViewController_.view.frame = frame;
	rootViewController_.simpleCoreData = simpleCoreData_;
	
	navigationController_ = [[UINavigationController alloc] initWithRootViewController:rootViewController_];

	[window_ addSubview:navigationController_.view];
    [window_ makeKeyAndVisible];

	/*
	NSManagedObject *newManagedObject = [simpleCoreData_ newManagedObject:@"Person"];
	[newManagedObject setValue:@"ほほほ" forKey:@"firstName"];
    [newManagedObject setValue:@"ほほ" forKey:@"lastName"];
	[newManagedObject setValue:[NSNumber numberWithInt:5] forKey:@"age"];
	[simpleCoreData_ saveContext];
	 */
	
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
	[simpleCoreData_ saveContext];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
	[simpleCoreData_ saveContext];
}



#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[simpleCoreData_ release];
	[rootViewController_ release];
	[navigationController_ release];
    [window_ release];
    [super dealloc];
}


@end
