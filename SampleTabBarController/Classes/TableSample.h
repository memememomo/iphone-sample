//
//  TableSample.h
//  UITable
//
//  Created by Your Name on 11/01/31.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OverlayViewController;

@interface TableSample : UITableViewController<UISearchBarDelegate> {
	NSMutableArray *dataSource_;
	NSMutableArray *items_;
	
	
	UISegmentedControl *segment_;
	NSInteger page_;
	
	OverlayViewController *overlayController_;
	BOOL searching_;
	BOOL letUserSelectRow_;
	
	NSString *searchKeyword_;
	
	BOOL deleteFlag_;
}

@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) NSString *searchKeyword;

- (void)updateSegment:(UISegmentedControl *)segment;
- (void)searchKeyword:(UISearchBar *)searchBar;
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
- (void)insertItems;

@end


/*
 * 検索キーワードを入力しているときに、覆いかぶさる灰色のレイヤー
 */

@interface OverlayViewController : UIViewController {
	UIViewController *rvController_;
}

@property (nonatomic, retain) UIViewController *rvController;

@end