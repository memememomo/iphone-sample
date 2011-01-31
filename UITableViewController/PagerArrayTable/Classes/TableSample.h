//
//  TableSample.h
//  UITable
//
//  Created by Your Name on 11/01/31.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TableSample : UITableViewController {
	NSMutableArray *items_;
	
	UISegmentedControl *segment_;
	NSInteger page_;
}

- (void)updateSegment:(UISegmentedControl *)segment;

@end
