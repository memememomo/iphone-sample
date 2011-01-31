//
//  SampleTabBarControllerAppDelegate.m
//  SampleTabBarController
//
//  Created by Your Name on 11/01/31.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import "SampleTabBarControllerAppDelegate.h"
#import "FirstController.h"
#import "TableSample.h"


@implementation SampleTabBarControllerAppDelegate



#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	
	CGRect frame = [[UIScreen mainScreen] bounds];
	window_ = [[UIWindow alloc] initWithFrame:frame];
	
	
	NSMutableArray *controllers = [[[NSMutableArray alloc] init] autorelease];
	UINavigationController *navigation;
	
	
	// タブバー
	tabBarController_ = [[UITabBarController alloc] init];
	tabBarController_.delegate = self;
	

	// FirstController
	FirstController *firstController = [[[FirstController alloc] 
										 initWithNibName:@"FirstController" bundle:nil]
										autorelease];
	firstController.title = @"first";
	navigation = [[UINavigationController alloc] initWithRootViewController:firstController];
	[controllers addObject:navigation];
	[navigation release];
	navigation = nil;
	
	
	// TableSample
	TableSample *tableSample = [[[TableSample alloc] init] autorelease];
	navigation = [[UINavigationController alloc] initWithRootViewController:tableSample];
	navigation.delegate = self;
	[controllers addObject:navigation];
	[navigation release];
	navigation = nil;
				  
	
	[tabBarController_ setViewControllers:controllers animated:NO];
	
	[window_ addSubview:tabBarController_.view];
    [window_ makeKeyAndVisible];
    
    return YES;
}


/*
 * UITableViewのview*Appearが呼ばれない件の解決策
 */

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	[viewController viewDidAppear:animated];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	[viewController viewWillAppear:animated];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	[((UINavigationController*)viewController).topViewController viewWillAppear:YES];
	[((UINavigationController*)viewController).topViewController viewDidAppear:YES];
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
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[tabBarController_ release];
    [window_ release];
    [super dealloc];
}


@end
