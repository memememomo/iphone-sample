//
//  TableSample.m
//  UITable
//
//  Created by Your Name on 11/01/31.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import "TableSample.h"

static int ROWS_IN_PAGE = 2;

@implementation TableSample


/*
 * 初期化と後処理
 */

- (void)dealloc 
{
	[segment_ release];
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
	NSFetchedResultsController *fetchedResultController = [factory fetchedResultsController:request AndSectionNameKeyPath:nil];
	simpleCoreData_ = [factory createSimpleCoreData:fetchedResultController];
	[simpleCoreData_ retain];
	
	
	// ページ移動のスイッチ
	NSArray *items = [NSArray arrayWithObjects:@"<", @">", nil];
	segment_ = [[[UISegmentedControl alloc] initWithItems:items] autorelease];
	segment_.frame = CGRectMake( 0, 0, 40, 30);
	segment_.selectedSegmentIndex = UISegmentedControlNoSegment;
	segment_.segmentedControlStyle = UISegmentedControlStyleBar;
	segment_.momentary = YES;
	[segment_ addTarget:self
				 action:@selector(segmentedControlClicked:)
	   forControlEvents:UIControlEventValueChanged];
	
	UIBarButtonItem *barButton = [[[UIBarButtonItem alloc] 
								   initWithCustomView:segment_]
								  autorelease];
	self.navigationItem.rightBarButtonItem = barButton;
	
	[self updateSegment:segment_];
	
	
	// ページ番号を初期化
	page_ = 0;
	
	
	// テストデータを作る
	[self deleteTestData];
	[self insertTestData];
}


/*
 * 各セクションの項目数を返す
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// データ数を取得
	id<NSFetchedResultsSectionInfo> sectionInfo = [[simpleCoreData_.fetchedResultsController sections] objectAtIndex:section];
	NSInteger rows = [sectionInfo numberOfObjects];
	
	// セグメント情報を更新
	[self updateSegment:segment_];
	
	// ページに応じて行数を変える
	if (rows >= (page_ + 1) * ROWS_IN_PAGE) {
		return ROWS_IN_PAGE;
	} else {
		return rows - page_ * ROWS_IN_PAGE;
	}	
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
	
	
	// ページに応じて、indexPathを計算する
	NSInteger row = (page_ * ROWS_IN_PAGE) + indexPath.row;
	NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:row inSection:indexPath.section];

	
	// indexPathからデータを取得してくる
	NSManagedObject *managedObject = [simpleCoreData_.fetchedResultsController objectAtIndexPath:newIndexPath];

	
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
	// ページに応じて、indexPathを計算する
	NSInteger row = (page_ * ROWS_IN_PAGE) + indexPath.row;
	NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:row inSection:indexPath.section];
	
	NSManagedObject *managedObject = [simpleCoreData_.fetchedResultsController objectAtIndexPath:newIndexPath];
	
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
		// ページに応じて、indexPathを計算する
		NSInteger row = (page_ * ROWS_IN_PAGE) + indexPath.row;
		NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:row inSection:indexPath.section];
		
		
		// 削除
		[simpleCoreData_ deleteObjectWithIndexPath:newIndexPath];
		
		// テーブルから該当セルを削除(TODO:うまく動かない、削除後のデータとページャのROWS_IN_PAGEの値があわないのが原因)
		//[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
		//										  withRowAnimation:UITableViewRowAnimationFade];
		
		[self updateSegment:segment_];
		
		[tableView reloadData];
	}
}


#pragma mark --- SegmentedControl Delegate ---
#pragma mark ---------------------------------


/*
 * セグメントがタップされたときに呼び出される
 */

- (void)segmentedControlClicked:(id)sender 
{
	UISegmentedControl *segment = sender;
	NSInteger selected = segment.selectedSegmentIndex;
	
	if (selected == 0) {
		if (page_ > 0) {
			page_--;
		}
	} else if (selected == 1) {
		page_++;
	}
	
	[self updateSegment:segment];
	
	[self.tableView reloadData];
}


/*
 * セグメントの選択不可などの設定を更新する
 */

- (void)updateSegment:(UISegmentedControl*)segment
{
	if (page_ == 0) {
		[segment setEnabled:NO forSegmentAtIndex:0];
	} else {
		[segment setEnabled:YES forSegmentAtIndex:0];
	}
	
	
	NSInteger rows = [simpleCoreData_ countObjects];
	
	if (rows <= (page_+1) * ROWS_IN_PAGE) {
		[segment setEnabled:NO forSegmentAtIndex:1];
	} else {
		[segment setEnabled:YES forSegmentAtIndex:1];
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