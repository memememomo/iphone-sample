
//
//  SimpleCoreData.h
//  CoreDataTest
//
//  Created by memememomo on 10/12/17.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SimpleCoreData : NSObject<NSFetchedResultsControllerDelegate> {
	NSInteger fetchBatchSize_;
	NSString *cacheName_;
	NSString *xcdatamodelName_; 
	NSString *sqliteName_;
	id fetchDelegate_;
}

@property (nonatomic, retain) NSString *cacheName;
@property (nonatomic, retain) NSString *xcdatamodelName;
@property (nonatomic, retain) NSString *sqliteName;
@property (nonatomic, retain) id fetchDelegate;

- (NSManagedObject *)fetchObject:(NSString *)entityName WithRow:(NSInteger)row AndSection:(NSInteger)section;
- (NSManagedObject *)fetchObject:(NSString *)entityName WithIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)countObjects:(NSString *)entityName;
- (NSInteger)countSections:(NSString *)entityName;
- (void)deleteObject:(NSString *)entityName WithRow:(NSInteger)row AndSection:(NSInteger)section;
- (void)deleteObject:(NSString *)entityName WithIndexPath:(NSIndexPath *)indexPath;
- (void)deleteObject:(NSString *)entityName WithObject:(NSManagedObject *)managedObject;
- (NSManagedObject *)newManagedObject:(NSString *)entryName;

- (void)saveContext;
- (NSFetchedResultsController *)fetchedResultsController:(NSString *)entityName;
- (NSManagedObjectContext *)managedObjectContext;
- (NSManagedObjectModel *)managedObjectModel;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSURL *)applicationDocumentsDirectory;

@end
