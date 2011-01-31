//
//  TableSample.m
//  UITable
//
//  Created by Your Name on 11/01/31.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import "TableSample.h"


@implementation TableSample

static int ROWS_IN_PAGE = 2;

/*
 * 初期化と後処理
 */

- (void)dealloc 
{
	[items_ release];
	[segment_ release];
	[super dealloc];
}

- (id)init
{
	// テーブルの表示形式を指定する
	if ( (self = [super initWithStyle:UITableViewStylePlain]) ) {
	//if ( (self = [super initWithStyle:UITableViewStyleGrouped]) ) {
		self.title = @"PagerTable";
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
	
	
	// データ初期化
	items_ = [NSMutableArray arrayWithObjects:
			  @"Monkey", @"Dog", @"Lion", @"Elephant",
			  @"Snake", @"Gecko",
			  @"Frog", @"Newts",
			  @"Shark", @"Salmon", nil];
	[items_ retain];
	
	
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
}


/*
 * 各セクションの項目数を返す
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger rows = [items_ count];
	
	if ( rows >= (page_ + 1) * ROWS_IN_PAGE ) {
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
	
	// ページャに合わせてデータの位置を計算
	NSInteger row = (page_ * ROWS_IN_PAGE) + indexPath.row;
	
	// セクションにある項目の中のrow番目のデータを取得
	NSString *text = [items_ objectAtIndex:row];

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
	NSString *message = [items_ objectAtIndex:indexPath.row];
	
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
		[items_ removeObjectAtIndex:indexPath.row];
		
		// テーブルから該当セルを削除
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
						 withRowAnimation:UITableViewRowAnimationFade];
		
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
	
	
	NSInteger rows = [items_ count];
	
	if (rows <= (page_+1) * ROWS_IN_PAGE) {
		[segment setEnabled:NO forSegmentAtIndex:1];
	} else {
		[segment setEnabled:YES forSegmentAtIndex:1];
	}
}


@end
