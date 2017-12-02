//
//  HTMessageController.m
//  GMat
//
//  Created by hublot on 2016/10/19.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTMessageController.h"
#import <UITableView+HTSeparate.h>
#import "THMineMessageCell.h"
#import "UIScrollView+HTRefresh.h"
#import "HTMessageModel.h"

@interface HTMessageController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *modelArray;

@end

@implementation HTMessageController

- (void)dealloc {
	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
	__weak HTMessageController *weakSelf = self;
	[self.tableView ht_setRefreshBlock:^(NSString *pageSize, NSString *currentPage) {
		HTNetworkModel *networkModel = [HTNetworkModel modelForOnlyCacheNoInterfaceForScrollViewWithCacheStyle:HTCacheStyleSingleUser];
		[HTRequestManager requestMineMessageWithNetworkModel:networkModel pageSize:pageSize currentPage:currentPage complete:^(id response, HTError *errorModel) {
			if (errorModel.existError) {
				[weakSelf.tableView ht_endRefreshWithModelArrayCount:errorModel.errorType];
				return;
			}
			NSMutableArray *modelArray = [HTMessageModel mj_objectArrayWithKeyValuesArray:response[@"messageslist"]];
			if (currentPage.integerValue == 1) {
				weakSelf.modelArray = modelArray;
			} else {
				[weakSelf.modelArray addObjectsFromArray:modelArray];
			}
			[weakSelf.tableView ht_endRefreshWithModelArrayCount:modelArray.count];
			[weakSelf.tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
				sectionMaker.modelArray(weakSelf.modelArray);
			}];
		}];
	}];
	[self.tableView ht_startRefreshHeader];
}

- (void)initializeUserInterface {
	self.navigationItem.title = @"消息记录";
	UIView *backgroundView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(HTMineMessagePointLineLeftDistance, 0, 1 / [UIScreen mainScreen].scale, self.view.ht_h)];
    lineView.backgroundColor = [UIColor ht_colorStyle:HTColorStyleSecondarySeparate];
	[backgroundView addSubview:lineView];
	self.tableView.backgroundView = backgroundView;
	[self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
		_tableView.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
		_tableView.allowsSelection = false;
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            sectionMaker.cellClass([THMineMessageCell class]);
        }];
	}
	return _tableView;
}

- (NSMutableArray *)modelArray {
	if (!_modelArray) {
		_modelArray = [NSMutableArray new];
	}
	return _modelArray;
}

@end
