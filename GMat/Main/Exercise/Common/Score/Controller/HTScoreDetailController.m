//
//  HTScoreDetailController.m
//  GMat
//
//  Created by hublot on 16/11/27.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTScoreDetailController.h"

@interface HTScoreDetailController ()

@end

@implementation HTScoreDetailController

- (void)dealloc {
	self.tableView.tableHeaderView = nil;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	[self.view addSubview:self.tableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] init];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_tableView.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
	}
	return _tableView;
}


- (HTQuestionView *)headerQuestionView {
	if (!_headerQuestionView) {
		_headerQuestionView = [[HTQuestionView alloc] init];
	}
	return _headerQuestionView;
}

@end
