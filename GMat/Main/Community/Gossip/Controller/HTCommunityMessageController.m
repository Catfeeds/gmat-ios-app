//
//  HTCommunityMessageController.m
//  GMat
//
//  Created by hublot on 2016/11/23.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTCommunityMessageController.h"
#import "UIScrollView+HTRefresh.h"
#import <UITableView+HTSeparate.h>
#import "HTCommunityMessageLayoutModel.h"
#import "HTCommunityMessageCell.h"
#import "HTCommunityDetailController.h"
#import "HTLoginManager.h"
#import "HTCommunityController.h"
#import "HTManagerController.h"

@interface HTCommunityMessageController ()

@property (nonatomic, strong) NSMutableArray <HTCommunityMessageLayoutModel *> *messageLayoutModelArray;

@property (nonatomic, strong) UITableView *tabelView;

@end

@implementation HTCommunityMessageController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[self.tabelView ht_startRefreshHeader];
}

- (void)initializeDataSource {
    __weak HTCommunityMessageController *weakSelf = self;
	[self.tabelView ht_setRefreshBlock:^(NSString *pageSize, NSString *currentPage) {
		HTNetworkModel *networkModel = [HTNetworkModel modelForOnlyCacheNoInterfaceForScrollViewWithCacheStyle:HTCacheStyleSingleUser];
		[HTRequestManager requestGossipMessageWithNetworkModel:networkModel complete:^(id response, HTError *errorModel) {
			if (errorModel.existError) {
				[weakSelf.tabelView ht_endRefreshWithModelArrayCount:errorModel.errorType];
				return;
			}
			dispatch_async(dispatch_get_global_queue(0, 0), ^{
				NSMutableArray *modelArray = [HTCommunityMessageModel mj_objectArrayWithKeyValuesArray:response];
				if (modelArray.count) {
					weakSelf.messageLayoutModelArray = [@[] mutableCopy];
					[modelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
						HTCommunityMessageLayoutModel *messageLayoutModel = [HTCommunityMessageLayoutModel messageLayoutModelWithMessageModel:obj];
						[weakSelf.messageLayoutModelArray addObject:messageLayoutModel];
					}];
					dispatch_async(dispatch_get_main_queue(), ^{
						HTCommunityController *communityController = [HTManagerController defaultManagerController].communityController;
						__weak typeof(HTCommunityController) *weakCommunityController = communityController;
						[communityController.communityHeaderView setRingCount:0 completeBlock:^{
							weakCommunityController.tableView.tableHeaderView = weakCommunityController.communityHeaderView;
						}];
						[weakSelf.tabelView ht_endRefreshWithModelArrayCount:modelArray.count];
						[weakSelf.tabelView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
							sectionMaker.modelArray(weakSelf.messageLayoutModelArray);
						}];
					});
				} else {
					dispatch_async(dispatch_get_main_queue(), ^{
						[weakSelf.tabelView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
							sectionMaker.modelArray(@[]);
						}];
						[weakSelf.tabelView ht_endRefreshWithModelArrayCount:modelArray.count];
					});
				}
			});
		}];
	}];
}

- (void)initializeUserInterface {
	self.navigationItem.title = @"新消息";
	[self.view addSubview:self.tabelView];
}

- (UITableView *)tabelView {
	if (!_tabelView) {
		_tabelView = [[UITableView alloc] initWithFrame:self.view.bounds];
		_tabelView.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
        __weak HTCommunityMessageController *weakSelf = self;
        
        [_tabelView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [sectionMaker.cellClass([HTCommunityMessageCell class]) didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof HTCommunityMessageLayoutModel *model) {
                HTCommunityDetailController *communityDetailController = [[HTCommunityDetailController alloc] init];
                communityDetailController.communityIdString = model.originModel.gossipId;
                [weakSelf.navigationController pushViewController:communityDetailController animated:true];
            }];
        }];
	}
	return _tabelView;
}

@end
