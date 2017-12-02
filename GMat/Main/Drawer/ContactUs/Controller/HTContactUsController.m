//
//  HTContrctUsController.m
//  GMat
//
//  Created by hublot on 2016/10/21.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTContactUsController.h"
#import "HTContactUsModel.h"


@interface HTContactUsController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray <HTContactUsModel *> *modelArray;

@end

@implementation HTContactUsController

- (void)dealloc {
    
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	self.navigationItem.title = @"联系我们";
	[self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.modelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	cell.textLabel.text = self.modelArray[indexPath.section].titleName;
	cell.textLabel.textColor = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
	cell.textLabel.font = [UIFont ht_fontStyle:HTFontStyleTitleLarge];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:true];
	if (indexPath.section == 3) {
		[HTAlert title:@"是否立刻拨打【4001816180】?" sureAction:^{
			NSMutableString *phoneNumber = [[NSMutableString alloc] initWithFormat:@"tel:%@",@"4001816180"];
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
		}];
	} else {
		UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		pasteboard.string = cell.textLabel.text;
		[HTAlert title:@"已复制至剪贴板"];
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return self.modelArray[section].headerTitle;
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
		_tableView.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		[_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
		_tableView.delegate = self;
		_tableView.dataSource = self;
	}
	return _tableView;
}

- (NSArray<HTContactUsModel *> *)modelArray {
	if (!_modelArray) {
		_modelArray = [HTContactUsModel packModelArray];
	}
	return _modelArray;
}

@end
