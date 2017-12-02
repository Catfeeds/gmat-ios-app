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
#import "HTLiveDetailViewController.h"


@interface HTCommunityMessageController ()

@property (nonatomic, strong) NSMutableArray <HTCommunityMessageLayoutModel *> *messageLayoutModelArray;

@property (nonatomic, strong) UITableView *tabelView;

@end

@implementation HTCommunityMessageController

- (id)initWithtype:(HTCommunityMessageControllerType) type;
{
	if (self = [super init]) {
		_type = type;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
	[self.tabelView ht_startRefreshHeader];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
}



- (void)initializeDataSource {
    __weak HTCommunityMessageController *weakSelf = self;
	[self.tabelView ht_setRefreshBlock:^(NSString *pageSize, NSString *currentPage) {
		HTNetworkModel *networkModel = [HTNetworkModel modelForOnlyCacheNoInterfaceForScrollViewWithCacheStyle:HTCacheStyleSingleUser];
		if (weakSelf.type == HTCommunityMessage) {
			[HTRequestManager requestGossipMessageWithNetworkModel:networkModel complete:^(id response, HTError *errorModel) {
				if (errorModel.existError) {
					[weakSelf.tabelView ht_endRefreshWithModelArrayCount:errorModel.errorType];
					return;
				}
				
				NSMutableArray *modelArray = [HTCommunityMessageModel mj_objectArrayWithKeyValuesArray:response];
				[self loadData:modelArray];
			}];
		}else {
			[HTRequestManager requestLiveMessageWithNetworkModel:networkModel complete:^(id response, HTError *errorModel) {
				
				NSMutableArray *modelArray = [HTLiveMessageModel mj_objectArrayWithKeyValuesArray:response];
				NSMutableArray *tempModelArray =  [NSMutableArray array];
				[modelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
					HTCommunityMessageModel * model = [[HTCommunityMessageModel alloc]init];
					HTLiveMessageModel *liveModel = (HTLiveMessageModel *)obj;
					model.Id 		    = liveModel.Id;
					model.content       = liveModel.content;
					model.userImage     = liveModel.userImage;
					model.uid 		    = liveModel.uid;
					model.userName      = liveModel.userName;
					model.receiverId    = liveModel.receiverId;
					model.gossipId      = liveModel.liveId;
					model.type 			= liveModel.type;
					model.gossipContent = liveModel.liveContent;
					model.createTime    = liveModel.createTime;
					[tempModelArray addObject:model];
				}];
				[self loadData:tempModelArray];
			}];
		}
		
	}];
}

- (void)loadData:(NSMutableArray *) modelArray{
	__weak HTCommunityMessageController *weakSelf = self;
	dispatch_async(dispatch_get_global_queue(0, 0), ^{

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
				
				if (weakSelf.type == HTCommunityMessage) {
					HTCommunityDetailController *communityDetailController = [[HTCommunityDetailController alloc] init];
					communityDetailController.communityIdString = model.originModel.gossipId;
					[weakSelf.navigationController pushViewController:communityDetailController animated:true];
				}else{
					HTLiveDetailViewController *liveDetail = STORYBOARD_VIEWCONTROLLER(@"Community",@"HTLiveDetailViewController");
					liveDetail.liveID = model.originModel.gossipId;
					[weakSelf.navigationController pushViewController:liveDetail animated:YES];
				}
            }];
        }];
	}
	return _tabelView;
}

@end
