//
//  HTCourseTryListenController.m
//  GMat
//
//  Created by hublot on 16/10/13.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTTryListenController.h"
#import "HTTryListenModel.h"
#import "HTTryListenHeaderView.h"
#import "HTTryListenCell.h"
#import <UIScrollView+HTRefresh.h>
#import <UITableView+HTSeparate.h>
#import "HTTryListenHeaderView.h"
#import "HTTryListenWebController.h"

@interface HTTryListenController ()

@property (nonatomic, strong) HTTryListenHeaderView *tableHeaderView;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HTTryListenController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
	__weak typeof(self) weakSelf = self;
	[self.tableView ht_setRefreshBlock:^(NSString *pageSize, NSString *currentPage) {
		HTNetworkModel *networkModel = [HTNetworkModel modelForOnlyCacheNoInterfaceForScrollViewWithCacheStyle:HTCacheStyleAllUser];
		[HTRequestManager requestTryListenCourseListWithNetworkModel:networkModel complete:^(id response, HTError *errorModel) {
			if (errorModel.existError) {
				[weakSelf.tableView ht_endRefreshWithModelArrayCount:errorModel.errorType];
				return;
			}
			NSArray *modelArray = [HTTryListenModel mj_objectArrayWithKeyValuesArray:response];
			[weakSelf.tableView ht_endRefreshWithModelArrayCount:modelArray.count];
			[modelArray enumerateObjectsUsingBlock:^(HTTryListenModel *model, NSUInteger index, BOOL * _Nonnull stop) {
				[model appendDataWithIndex:index];
			}];
			[weakSelf.tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
				sectionMaker.modelArray(modelArray);
			}];
		}];
	}];
	[self.tableView ht_startRefreshHeader];
}

- (void)initializeUserInterface {
	self.navigationItem.title = @"试听课";
	self.tableView.tableHeaderView = self.tableHeaderView;
	[self.view addSubview:self.tableView];
	[self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
}

- (HTTryListenHeaderView *)tableHeaderView {
	if (!_tableHeaderView) {
		_tableHeaderView = [[HTTryListenHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
	}
	return _tableHeaderView;
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] init];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		__weak typeof(self) weakSelf = self;
		CGFloat height = MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [sectionMaker.cellClass([HTTryListenCell class])
			 .rowHeight((height - 64 - 15 - 30) / 4) didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof HTTryListenModel *model) {
                HTTryListenWebController *webController = [[HTTryListenWebController alloc] initWithAddress:model.webHtmlUrlString];
                [weakSelf.navigationController pushViewController:webController animated:true];
            }];
        }];
	}
	return _tableView;
}

@end
