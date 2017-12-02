//
//  HTCommunityDetailController.m
//  GMat
//
//  Created by hublot on 2016/10/26.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTCommunityDetailController.h"
#import "HTCommunityDetailHeaderView.h"
#import <UITableView+HTSeparate.h>
#import "THToeflDiscoverDetailSpeakView.h"
#import "HTLoginManager.h"
#import "HTCommunityReplyCell.h"
#import "UIScrollView+HTRefresh.h"
#import "HTCommunityLayoutModel.h"


@interface HTCommunityDetailController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HTCommunityDetailHeaderView *detailHeaderView;

@property (nonatomic, strong) THToeflDiscoverDetailSpeakView *bottomSpeakView;

@property (nonatomic, strong) HTCommunityReplyLayoutModel *willReplyModel;

@property (nonatomic, strong) HTCommunityLayoutModel *communityLayoutModel;

@end

@implementation HTCommunityDetailController

- (void)dealloc {
	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.communityLayoutModel.originModel && self.detailDidDismissBlock) {
        self.detailDidDismissBlock(self.communityLayoutModel.originModel);
    }
}
- (void)initializeDataSource {
	__weak HTCommunityDetailController *weakSelf = self;
	[self.tableView ht_setRefreshBlock:^(NSString *pageSize, NSString *currentPage) {
		HTNetworkModel *networkModel = [HTNetworkModel modelForOnlyCacheNoInterfaceForScrollViewWithCacheStyle:HTCacheStyleAllUser];
		[HTRequestManager requestGossipDetailWithNetworkModel:networkModel gossipIdString:weakSelf.communityIdString complete:^(id response, HTError *errorModel) {
			if (errorModel.existError) {
				[weakSelf.tableView ht_endRefreshWithModelArrayCount:errorModel.errorType];
				return;
			}
			dispatch_async(dispatch_get_global_queue(0, 0), ^{
				HTCommunityModel *communityModel = [HTCommunityModel mj_objectWithKeyValues:response];
				weakSelf.communityLayoutModel = [HTCommunityLayoutModel layoutModelWithOriginModel:communityModel isDetail:true];
				dispatch_async(dispatch_get_main_queue(), ^{
					[weakSelf.detailHeaderView setModel:weakSelf.communityLayoutModel row:0 type:HTCommunityTypeGossip isShowDelete:NO];
					weakSelf.tableView.tableHeaderView = weakSelf.detailHeaderView;
					[weakSelf.tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
						sectionMaker.modelArray(weakSelf.communityLayoutModel.replyLayoutModelArray);
					}];
					[weakSelf.tableView ht_endRefreshWithModelArrayCount:1];
				});
			});
		}];
	}];
	[self.tableView ht_startRefreshHeader];
}

- (void)initializeUserInterface {
	[self.view addSubview:self.tableView];
	[self.view addSubview:self.bottomSpeakView];
	self.navigationItem.title = @"文章详情";
	
	__weak HTCommunityDetailController *weakSelf = self;
	[self ht_addFallowKeyBoardView:self.view style:HTKeyBoardStylePoint customKeyBoardHeight:^CGFloat(HTKeyboardModel *fallowModel, CGFloat originHeight, CGFloat duration) {
		fallowModel.style = weakSelf.view.ht_h - weakSelf.bottomSpeakView.ht_h - originHeight - 64 <= weakSelf.tableView.contentSize.height ? HTKeyBoardStylePoint : HTKeyBoardStyleHeight;
		return originHeight;
	}];
	[self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(weakSelf.view);
		make.left.right.mas_equalTo(weakSelf.view);
		make.bottom.mas_equalTo(weakSelf.bottomSpeakView.mas_top);
	}];
	[self.bottomSpeakView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.left.right.mas_equalTo(weakSelf.view);
	}];
	[self.bottomSpeakView.speakTextView bk_addObserverForKeyPath:@"contentSize" options:NSKeyValueObservingOptionInitial task:^(id obj, NSDictionary *change) {
		if (weakSelf.bottomSpeakView.speakTextView.contentSize.height <= 150) {
			[weakSelf.bottomSpeakView mas_updateConstraints:^(MASConstraintMaker *make) {
				make.height.mas_equalTo(weakSelf.bottomSpeakView.speakTextView.contentSize.height + 10 + 10);
			}];
			[weakSelf.bottomSpeakView layoutSubviews];
		}
	}];
	
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
		_tableView.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
		_tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
		_tableView.separatorInset = UIEdgeInsetsZero;
		_tableView.tableFooterView = [[UIView alloc] init];
		__weak HTCommunityDetailController *weakSelf = self;
		[_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
			[sectionMaker.cellClass([HTCommunityReplyCell class])
			 .footerView([[UIView alloc] init]) didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof NSObject *model) {
				weakSelf.willReplyModel = model;
				[weakSelf.bottomSpeakView becomeFirstResponderWithStyle:THToeflDiscoverDetailSpeakViewEditStyleSubComment placeHolder:[NSString stringWithFormat:@"@%@: ", weakSelf.willReplyModel.originReplyModel.uName]];
			}];
		}];
	}
	return _tableView;
}

- (HTCommunityDetailHeaderView *)detailHeaderView {
	if (!_detailHeaderView) {
		_detailHeaderView = [[HTCommunityDetailHeaderView alloc] init];
	}
	return _detailHeaderView;
}

- (THToeflDiscoverDetailSpeakView *)bottomSpeakView {
	if (!_bottomSpeakView) {
		__weak HTCommunityDetailController *weakSelf = self;
		_bottomSpeakView = [[THToeflDiscoverDetailSpeakView alloc] initWithFrame:CGRectZero shouldBeginBlock:^{
			
		} shouldSendBlock:^{
			if (!weakSelf.communityLayoutModel) {
				[HTAlert title:@"获取失败"];
				return;
			}
			switch (weakSelf.bottomSpeakView.style) {
				case THToeflDiscoverDetailSpeakViewEditStyleComment: {
					HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
					networkModel.autoAlertString = @"正在回复中";
					networkModel.offlineCacheStyle = HTCacheStyleNone;
					networkModel.autoShowError = true;
					[HTRequestManager requestGossipReplyGossipOwnerWithNetworkModel:networkModel replyContent:weakSelf.bottomSpeakView.speakTextView.text communityLayoutModel:weakSelf.communityLayoutModel complete:^(id response, HTError *errorModel) {
						if (errorModel.existError) {
							return;
						}
						[HTAlert title:@"回复成功"];
						weakSelf.bottomSpeakView.speakTextView.text = @"";
						[weakSelf.bottomSpeakView becomeFirstResponderWithStyle:THToeflDiscoverDetailSpeakViewEditStyleComment placeHolder:@"我也说一句"];
						[weakSelf.bottomSpeakView.speakTextView endEditing:true];
						[weakSelf.tableView ht_startRefreshHeader];
					}];
					break;
				}
				case THToeflDiscoverDetailSpeakViewEditStyleSubComment: {
					HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
					networkModel.autoAlertString = @"正在回复中";
					networkModel.offlineCacheStyle = HTCacheStyleNone;
					networkModel.autoShowError = true;
					[HTRequestManager requestGossipReplyGossipLoopReplyWithNetworkModel:networkModel replyContent:weakSelf.bottomSpeakView.speakTextView.text communityLayoutModel:weakSelf.communityLayoutModel beingReplyModel:weakSelf.willReplyModel complete:^(id response, HTError *errorModel) {
						if (errorModel.existError) {
							return;
						}
						[HTAlert title:@"回复成功"];
						weakSelf.bottomSpeakView.speakTextView.text = @"";
						[weakSelf.bottomSpeakView becomeFirstResponderWithStyle:THToeflDiscoverDetailSpeakViewEditStyleComment placeHolder:@"我也说一句"];
						[weakSelf.bottomSpeakView.speakTextView endEditing:true];
						[weakSelf.tableView ht_startRefreshHeader];
					}];
					break;
				}
			}
		}];
	}
	return _bottomSpeakView;
}

@end
