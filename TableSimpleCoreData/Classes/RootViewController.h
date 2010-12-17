//
//  RootViewController.h
//  TableSimpleCoreData
//
//  Created by Your Name on 10/12/17.
//  Copyright 2010 Your Org Name. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleCoreData.h"

@interface RootViewController : UITableViewController<NSFetchedResultsControllerDelegate> {
	SimpleCoreData *simpleCoreData_;
}

@property (nonatomic, retain) SimpleCoreData *simpleCoreData;

@end
