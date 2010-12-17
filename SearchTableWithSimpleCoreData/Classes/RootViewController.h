//
//  RootViewController.h
//  FastMemo
//
//  Created by Your Name on 10/12/18.
//  Copyright 2010 Your Org Name. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleCoreData.h"

@interface RootViewController : UITableViewController<UISearchDisplayDelegate> {
	SimpleCoreData *simpleCoreData_;
	UISearchDisplayController *searchDisplay_;
	UISearchBar *searchBar_;
}

@property (nonatomic, retain) SimpleCoreData *simpleCoreData;

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope;

@end
