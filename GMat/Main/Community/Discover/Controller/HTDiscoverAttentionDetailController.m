//
//  HTDiscoverAttentionDetailController.m
//  GMat
//
//  Created by hublot on 2017/7/5.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTDiscoverAttentionDetailController.h"
#import "HTDiscoverAttentionDetailHeaderView.h"
#import <UIScrollView+HTRefresh.h>
#import <UITableView+HTSeparate.h>
#import "HTDiscoverAttentionModel.h"
#import "THShareView.h"

@interface HTDiscoverAttentionDetailController ()

@property (nonatomic, strong) HTDiscoverAttentionModel *model;

@property (nonatomic, strong) HTDiscoverAttentionDetailHeaderView *headerView;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HTDiscoverAttentionDetailController

- (void)dealloc {
	self.tableView.tableHeaderView = nil;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	if (self.model && self.detailDidDismissBlock) {
		self.detailDidDismissBlock(self.model);
	}
}

- (void)initializeDataSource {
	__weak typeof(self) weakSelf = self;
	[self.tableView ht_setRefreshBlock:^(NSString *pageSize, NSString *currentPage) {
		HTNetworkModel *networkModel = [HTNetworkModel modelForOnlyCacheNoInterfaceForScrollViewWithCacheStyle:HTCacheStyleSingleUser];
		[HTRequestManager requestDiscoverInformationDetailWithNetworkModel:networkModel informationId:weakSelf.attentionId complete:^(id response, HTError *errorModel) {
			if (errorModel.existError) {
				[weakSelf.tableView ht_endRefreshWithModelArrayCount:errorModel.errorType];
				return;
			}
			HTDiscoverAttentionModel *discoverModel = [HTDiscoverAttentionModel mj_objectWithKeyValues:response];
			weakSelf.model = discoverModel;
			weakSelf.model.views = [NSString stringWithFormat:@"%ld", weakSelf.model.views.integerValue + 1];
			[weakSelf.tableView ht_endRefreshWithModelArrayCount:1];
			[weakSelf.headerView setModel:weakSelf.model tableView:weakSelf.tableView];
		}];
	}];
	[self.tableView ht_startRefreshHeader];
}

- (void)initializeUserInterface {
	__weak typeof(self) weakSelf = self;
	UIBarButtonItem *shareBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"Toeflshare"] style:UIBarButtonItemStylePlain handler:^(id sender) {
		[THShareView showTitle:weakSelf.model.contenttitle detail:weakSelf.model.contenttext image:HTPLACEHOLDERIMAGE url:@"http://bbs.viplgw.cn" type:SSDKContentTypeWebPage];
	}];
	shareBarButtonItem.tintColor = [UIColor whiteColor];
	self.navigationItem.rightBarButtonItems = @[shareBarButtonItem];
	[self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
		_tableView.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
	}
	return _tableView;
}

- (HTDiscoverAttentionDetailHeaderView *)headerView {
	if (!_headerView) {
		_headerView = [[HTDiscoverAttentionDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, 80)];
	}
	return _headerView;
}


@end
