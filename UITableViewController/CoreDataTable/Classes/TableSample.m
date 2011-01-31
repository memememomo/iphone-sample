//
//  TableSample.m
//  UITable
//
//  Created by Your Name on 11/01/31.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import "TableSample.h"


@implementation TableSample


/*
 * 初期化と後処理
 */

- (void)dealloc 
{
	[simpleCoreData_ release];
	[super dealloc];
}

- (id)init
{
	// テーブルの表示形式を指定する
	if ( (self = [super initWithStyle:UITableViewStylePlain]) ) {
	//if ( (self = [super initWithStyle:UITableViewStyleGrouped]) ) {
		self.title = @"CoreDataTable";
	}
	
	return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	// 選択されたセルのハイライトを解除する
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	// テーブルの削除を可能にする
	//[self.tableView setEditing:YES animated:YES];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	

	// CoreDataの初期化	
	SimpleCoreDataFactory *factory = [SimpleCoreDataFactory sharedCoreData];
	NSFetchRequest *request = [factory createRequest:@"data_source"];
	NSDictionary *sort = [[[NSDictionary alloc]
						   initWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithBool:NO], nil]
						   forKeys:[NSArray arrayWithObjects:@"timeStamp", nil]]
						  autorelease];
	[factory setSortDescriptors:request AndSort:sort];
	NSFetchedResultsController *fetchedResultController = [factory fetchedResultsController:request 
																	  AndSectionNameKeyPath:@"section"];
	simpleCoreData_ = [factory createSimpleCoreData:fetchedResultController];
	[simpleCoreData_ retain];
	
	
	// テストデータを作る
	[self deleteTestData];
	[self insertTestData];
}


/*
 * セクション数を返す
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [[simpleCoreData_.fetchedResultsController sections] count];
}


/*
 * セクション名を返す
 */

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	id<NSFetchedResultsSectionInfo> sectionInfo = [[simpleCoreData_.fetchedResultsController sections] objectAtIndex:section];
	return [sectionInfo name];
}


/*
 * 各セクションの項目数を返す
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	id<NSFetchedResultsSectionInfo> sectionInfo = [[simpleCoreData_.fetchedResultsController sections] objectAtIndex:section];
	return [sectionInfo numberOfObjects];
}


/*
 * セルの内容
 */

- (UITableViewCell *)tableView:(UITableView *)tableView
cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	static NSString *identifier = @"basis-cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if ( nil == cell ) {
		// 詳細情報なしの場合
		//cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
		//							  reuseIdentifier:identifier];
		
		// 詳細情報ありの場合
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
									  reuseIdentifier:identifier];
		[cell autorelease];
	}
	
	// indexPathからデータを取得してくる
	NSManagedObject *managedObject = [simpleCoreData_.fetchedResultsController objectAtIndexPath:indexPath];

	
	// セクションにある項目の中のrow番目のデータを取得
	NSString *text = [managedObject valueForKey:@"data"];

	// テキストを追加
	cell.textLabel.text = text;
	cell.detailTextLabel.text = @"detail";
	
	// 改行あり
	//cell.textLabel.numberOfLines = 0;
	
	// セルにコントロールを追加
	// [cell.contentView addSubview:nil];
	
	return cell;
}


/*
 * セルの幅を調整
 */
/*
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
	CGFloat height = 50.0f;
	
	
	// 表示する予定のテキスト（改行あり）
	NSString *text = @"date\ndate\ndate";

	// 最大の表示領域CGSize。このCGSize以上は文字列長がこのサイズを超える場合はすべて表示されない
	CGSize bounds = CGSizeMake(300, 10000);
	
	// 文字列描画に使用するフォント
	UIFont *font = [UIFontsystemFontOfSize:18];
	
	// 表示に必要なCGSize
	CGSize size = [text sizeWithFont:font constrainedToSize:bounds lineBreakMode:UILineBreakModeTailTruncation];
	
	CGFloat h = size.height - height;
	if ( h > 0 ) {
		height += h;
	}
	
	return height;
}
*/


/*
 * セル選択時のアクション
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSManagedObject *managedObject = [simpleCoreData_.fetchedResultsController objectAtIndexPath:indexPath];
	
	NSString *message = [managedObject valueForKey:@"data"];
	
	UIAlertView *alert = [[[UIAlertView alloc] init] autorelease];
	alert.message = message;
	[alert addButtonWithTitle:@"OK"];
	[alert show];
	

	// セレクトのハイライトを解除する
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


/*
 * 編集
 */

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ( UITableViewCellEditingStyleDelete == editingStyle ) {
		// 削除
		[simpleCoreData_ deleteObjectWithIndexPath:indexPath];
		
		// テーブルから該当セルを削除
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
												  withRowAnimation:UITableViewRowAnimationFade];
		
	}
}


/*
 * テストデータ
 */

- (void)insertTestData
{	
	// セクション名
	NSArray *keys = [NSArray arrayWithObjects:@"哺乳類", @"爬虫類", @"両生類", @"魚類", nil];
	
	// 各セクションのデータ
	NSArray *object1 = [NSArray arrayWithObjects:@"Monkey", @"Dog", @"Lion", @"Elephant", nil];
	NSArray *object2 = [NSArray arrayWithObjects:@"Snake", @"Gecko", nil];
	NSArray *object3 = [NSArray arrayWithObjects:@"Frog", @"Newts", nil];
	NSArray *object4 = [NSArray arrayWithObjects:@"Shark", @"Salmon", nil];
	NSArray *objects = [NSArray arrayWithObjects:object1, object2, object3, object4, nil];
	
	// セクション名とデータを合わせる
	NSDictionary *dataSource = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	
	
	for ( id key in [dataSource allKeys] ) {
		for ( NSString *data in [dataSource objectForKey:key] ) {
			NSManagedObject *newObject = [simpleCoreData_ newManagedObject];
			[newObject setValue:[NSDate date] forKey:@"timeStamp"];
			[newObject setValue:data forKey:@"data"];
			[newObject setValue:key forKey:@"section"];
			[simpleCoreData_ saveContext];
		}
	}
}


- (void)deleteTestData
{
	for ( NSManagedObject *object in [simpleCoreData_ fetchObjectAll] ) {
		[simpleCoreData_ deleteObjectWithObject:object];
	}
}


@end