//
//  RootViewController.m
//  FastMemo
//
//  Created by Your Name on 10/12/18.
//  Copyright 2010 Your Org Name. All rights reserved.
//

#import "RootViewController.h"


@implementation RootViewController

@synthesize simpleCoreData = simpleCoreData_;

- (void)dealloc {
	[simpleCoreData_ release];
	[searchDisplay_ release];
	[searchBar_ release];
	[super dealloc];
}


- (void)viewDidLoad {
	[super viewDidLoad];
	
	searchBar_ = [[UISearchBar alloc] initWithFrame:CGRectMake( 0, 0, 320, 30)];
	
	searchDisplay_ = [[UISearchDisplayController alloc]
					  initWithSearchBar:searchBar_
					  contentsController:self];
	searchDisplay_.delegate = self;
	searchDisplay_.searchResultsDataSource = self;
	searchDisplay_.searchResultsDelegate = self;
	self.tableView.tableHeaderView = searchBar_;
	
	[NSFetchedResultsController deleteCacheWithName:self.simpleCoreData.fetchDelegate];
}


- (NSInteger)tableView:(UITableView *)tableView {
	return [self.simpleCoreData countSections:@"Person"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.simpleCoreData countObjects:@"Person"];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *identifier = @"basis-cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if ( nil == cell ) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
		[cell autorelease];
	}
	
	NSManagedObject *managedObject = [self.simpleCoreData fetchObject:@"Person" WithIndexPath:indexPath];
	
	NSString *lastName  = [managedObject valueForKey:@"lastName"];
	NSString *firstName = [managedObject valueForKey:@"firstName"];
	int age = [[managedObject valueForKey:@"age"] intValue];
	
	cell.textLabel.numberOfLines = 0;
	cell.textLabel.text = [NSString stringWithFormat:@"Name:%@ %@ age:%d", firstName, lastName, age];
	cell.textLabel.textAlignment = UITextAlignmentLeft;
	
	return cell;
}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	
}


#pragma mark -
#pragma mark SearchTableDelegate


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
	[self filterContentForSearchText:searchString
							   scope:[[searchDisplay_.searchBar scopeButtonTitles]
									  objectAtIndex:[searchDisplay_.searchBar selectedScopeButtonIndex]]];
	
	return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchScope:(NSInteger)searchOption
{
	[self filterContentForSearchText:[searchDisplay_.searchBar text]
							   scope:[[searchDisplay_.searchBar scopeButtonTitles]
									  objectAtIndex:searchOption]];
	
	return YES;
}


- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
	NSString *query = searchDisplay_.searchBar.text;

	if ( query && query.length ) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstName contains[cd] %@ OR lastName contains[cd] %@", query, query];
		[[self.simpleCoreData fetchedResultsController:@"Person"].fetchRequest setPredicate:predicate];
		[NSFetchedResultsController deleteCacheWithName:self.simpleCoreData.cacheName];
	}
	
	NSError *error = nil;
	if ( ![[self.simpleCoreData fetchedResultsController:@"Person"] performFetch:&error] ) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);
	}		
}


@end
