//
//  TableSample.h
//  UITable
//
//  Created by Your Name on 11/01/31.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleCoreDataFactory.h"

@class OverlayViewController;

@interface TableSample : UITableViewController<UISearchBarDelegate> {
	SimpleCoreData *simpleCoreData_;
}

- (void)insertTestData;
- (void)deleteTestData;

@end
