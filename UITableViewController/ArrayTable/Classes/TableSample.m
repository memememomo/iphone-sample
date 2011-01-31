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
	[keys_ release];
	[dataSource_ release];
	[super dealloc];
}

- (id)init
{
	// テーブルの表示形式を指定する
	if ( (self = [super initWithStyle:UITableViewStylePlain]) ) {
	//if ( (self = [super initWithStyle:UITableViewStyleGrouped]) ) {
		self.title = @"SectionTable";
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
	
	// セクション名
	keys_ = [[NSMutableArray alloc] initWithObjects:@"哺乳類", @"爬虫類", @"両生類", @"魚類", nil];
	
	// 各セクションのデータ
	NSArray *object1 = [NSArray arrayWithObjects:@"Monkey", @"Dog", @"Lion", @"Elephant", nil];
	NSArray *object2 = [NSArray arrayWithObjects:@"Snake", @"Gecko", nil];
	NSArray *object3 = [NSArray arrayWithObjects:@"Frog", @"Newts", nil];
	NSArray *object4 = [NSArray arrayWithObjects:@"Shark", @"Salmon", nil];
	NSMutableArray *objects = [NSMutableArray arrayWithObjects:object1, object2, object3, object4, nil];
	
	// セクション名とデータを合わせる
	dataSource_ = [[NSMutableDictionary alloc] initWithObjects:objects forKeys:keys_];
}


/*
 * 各セクションの項目数を返す
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	id key = [keys_ objectAtIndex:section];
	return [[dataSource_ objectForKey:key] count];
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
	
	// section番目のセクション名を取得
	id key = [keys_ objectAtIndex:indexPath.section];
	
	// セクションにある項目の中のrow番目のデータを取得
	NSString *text = [[dataSource_ objectForKey:key] objectAtIndex:indexPath.row];

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
 * セクションの数を返す
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [keys_ count];
}


/*
 * section番目のセクション名を返す
 */
 
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [keys_ objectAtIndex:section];
}


/*
 * セル選択時のアクション
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	id key = [keys_ objectAtIndex:indexPath.section];
	NSString *message = [[dataSource_ valueForKey:key] objectAtIndex:indexPath.row];
	
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
		// セクション名を取得
		id key = [keys_ objectAtIndex:indexPath.section];
		
		// データソースから該当項目を削除
		NSMutableArray *rows = [NSMutableArray arrayWithArray:[dataSource_ objectForKey:key]];
		[rows removeObjectAtIndex:indexPath.row];
		
		[dataSource_ removeObjectForKey:key];
		if ([rows count] > 0) {
			[dataSource_ setObject:rows forKey:key];
		}
		
		// テーブルから該当セルを削除
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
						 withRowAnimation:UITableViewRowAnimationFade];
		
	}
}

@end
