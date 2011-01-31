//
//  TableSample.m
//  UITable
//
//  Created by Your Name on 11/01/31.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import "TableSample.h"


@implementation TableSample

@synthesize items = items_;
@synthesize searchKeyword = searchKeyword_;


static int ROWS_IN_PAGE = 2;

/*
 * 初期化と後処理
 */

- (void)dealloc 
{
	[dataSource_ release];
	[items_ release];
	[segment_ release];
	[overlayController_ release];	
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
	dataSource_ = [NSMutableArray arrayWithObjects:
				   @"Monkey", @"Dog", @"Lion", @"Elephant",
				   @"Snake", @"Gecko",
				   @"Frog", @"Newts",
				   @"Shark", @"Salmon", nil];
	[dataSource_ retain];
	self.items = [[[NSMutableArray alloc] init] autorelease];
	for (int i = 0; i < [dataSource_ count]; i++) {
		NSDictionary *dic = [NSDictionary dictionaryWithObject:[dataSource_ objectAtIndex:i] forKey:[NSString stringWithFormat:@"%d", i]];
		[self.items addObject:dic];
	}
	
	
	// 検索バー
	UISearchBar *searchBar = [[[UISearchBar alloc] init] autorelease];
	searchBar.frame = CGRectMake( 0, 0, self.tableView.bounds.size.width, 0);
	searchBar.delegate = self;
	searchBar.placeholder = @"search";
	[searchBar sizeToFit];
	self.navigationItem.titleView = searchBar;
	
	searching_ = NO;
	letUserSelectRow_ = YES;
	self.searchKeyword = @".";
	
	
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
	NSInteger rows = [self.items count];
	
	if ( rows >= (page_ + 1) * ROWS_IN_PAGE ) {
		if (deleteFlag_) {
			deleteFlag_ = NO;
			return ROWS_IN_PAGE - 1;
		} else {
			return ROWS_IN_PAGE;
		}
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
	NSString *text = [[[items_ objectAtIndex:row] allValues] objectAtIndex:0];

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
	NSString *message = [[[items_ objectAtIndex:indexPath.row] allValues] objectAtIndex:0];
	
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
		// ページャに合わせてデータの位置を計算
		NSInteger row = (page_ * ROWS_IN_PAGE) + indexPath.row;
		
		// 元のデータの位置を取得
		NSDictionary *dic = [items_ objectAtIndex:row];
		NSInteger index = [[[dic allKeys] objectAtIndex:0] intValue];


		// 削除
		[dataSource_ removeObjectAtIndex:index];
		[self insertItems];
		
		// テーブルから該当セルを削除(TODO:うまくいかない、デリート後のrowの数の返し方がよく分からない)
		//deleteFlag_ = YES;
		//[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
		//				 withRowAnimation:UITableViewRowAnimationFade];
		
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
	
	
	NSInteger rows = [items_ count];
	
	if (rows <= (page_+1) * ROWS_IN_PAGE) {
		[segment setEnabled:NO forSegmentAtIndex:1];
	} else {
		[segment setEnabled:YES forSegmentAtIndex:1];
	}
}


#pragma mark --- SearBarDelegate ---
#pragma mark -----------------------

/*
 * 検索キーワードを入力し始める
 */

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	searching_ = YES;
	letUserSelectRow_ = NO;
	self.tableView.scrollEnabled = NO;
	
	if (overlayController_ == nil) {
		overlayController_ = [[OverlayViewController alloc] init];
	}
	
	// オーバーレイヤーの高さを計算
	CGFloat height = self.tableView.contentSize.height;
	if ( height < self.view.frame.size.height ) {
		height = self.view.frame.size.height;
	}
	CGFloat yaxis = self.tableView.frame.origin.y;
	CGFloat width = self.tableView.frame.size.width;
	
	
	// オーバーレイヤ作成
	CGRect frame = CGRectMake( 0, yaxis, width, height );
	overlayController_.view.frame = frame;
	overlayController_.view.backgroundColor = [UIColor grayColor];
	overlayController_.view.alpha = 0.8;
	overlayController_.rvController = self;
	
	page_ = 0;
	
	[self.tableView insertSubview:overlayController_.view aboveSubview:self.view];
}


/*
 * キーボードの「検索」が押されたとき
 */

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[self searchKeyword:searchBar];
}


/*
 * 検索、現在はキーボードの「検索」が押されたときと、オーバーレイヤのビューがタップされたときに呼び出される
 */

- (void)searchKeyword:(UISearchBar*)searchBar 
{
	searching_ = NO;
	letUserSelectRow_ = YES;
	self.tableView.scrollEnabled = YES;
	
	[overlayController_.view removeFromSuperview];
	[searchBar resignFirstResponder];
	

	// 検索キーワードから正規表現を作成
	NSString *searchKeyword = searchBar.text;
	if ([searchKeyword isEqualToString:@""]) {
		// 入力されていなかったら、必ずマッチさせる
		searchKeyword = @".";
	}
	
	self.searchKeyword = searchKeyword;
	
	[self insertItems];
	
	
	[self updateSegment:segment_];
	[self.tableView reloadData];
}


/*
 * 検索キーワードに該当するデータをitems_に挿入する
 */

- (void)insertItems
{
	// 検索キーワードから正規表現を作成
	NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:self.searchKeyword
																			options:NSRegularExpressionCaseInsensitive
																			  error:nil];
	// 検索キーワードが含まれている文字列を取得
	self.items = [[[NSMutableArray alloc] init] autorelease];
	for ( int i = 0; i < [dataSource_ count]; i++ ) {
		NSString *string = [dataSource_ objectAtIndex:i];
		NSTextCheckingResult *match = [regexp firstMatchInString:string
														 options:NSRegularExpressionCaseInsensitive
														   range:NSMakeRange(0, string.length)];
		if (match.numberOfRanges > 0) {
			NSDictionary *dic = [NSDictionary dictionaryWithObject:string forKey:[NSString stringWithFormat:@"%d", i]];
			[self.items addObject:dic];
		}
	}
}

@end



#pragma mark --- OverlayViewController ---
#pragma mark -----------------------------

@implementation OverlayViewController

@synthesize rvController = rvController_;


/*
 * オーバーレイヤがタップされたとき
 */

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[rvController_ searchKeyword:rvController_.navigationItem.titleView];
}


/*
 * メモリの容量が少ない時に呼び出される
 */

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


/*
 * 後処理
 */

- (void)dealloc {
	[rvController_ release];
	[super dealloc];
}

@end
