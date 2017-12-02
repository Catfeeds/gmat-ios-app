//
//  HTReuseController.m
//  GMat
//
//  Created by hublot on 2016/11/1.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTReuseController.h"

@interface HTReuseController ()

@end

@implementation HTReuseController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self.view addSubview:self.tableView];
	self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setPageModel:(HTPageModel *)pageModel {
	_pageModel = pageModel;
	__weak HTReuseController *weakSelf = self;
	[self.tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
		sectionMaker.modelArray(weakSelf.pageModel.modelArray);
	}];
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.ht_w, self.view.ht_h - 44 - 64)];
		_tableView.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
	}
	return _tableView;
}

@end
