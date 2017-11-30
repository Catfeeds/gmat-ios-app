//
//  THToeflDiscoverDetailController.m
//  TingApp
//
//  Created by hublot on 16/9/4.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "THToeflDiscoverDetailController.h"
#import "THShareView.h"
#import "THToeflDiscoverDetailHeaderView.h"
#import "UITableView+HTSeparate.h"
#import <UIScrollView+HTRefresh.h>
#import "THToeflDiscoverCommentCell.h"
#import "HTUserManager.h"
#import <SDImageCache.h>
#import "THToeflDiscoverDetailSpeakView.h"

@interface THToeflDiscoverDetailController ()

@property (nonatomic, strong) THToeflDiscoverModel *model;

@property (nonatomic, strong) THToeflDiscoverDetailHeaderView *headerView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) THToeflDiscoverDetailSpeakView *bottomSpeakView;

@property (nonatomic, strong) NSString *becomFirstResponderPid;

@end

@implementation THToeflDiscoverDetailController

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
    __weak THToeflDiscoverDetailController *weakSelf = self;
    [self.tableView ht_setRefreshBlock:^(NSString *pageSize, NSString *currentPage) {
        HTNetworkModel *networkModel = [HTNetworkModel modelForOnlyCacheNoInterfaceForScrollViewWithCacheStyle:HTCacheStyleSingleUser];
        [HTRequestManager requestDiscoverItemDetailWithNetworkModel:networkModel discoverId:weakSelf.discoverId complete:^(id response, HTError *errorModel) {
            if (errorModel.existError) {
                [weakSelf.tableView ht_endRefreshWithModelArrayCount:errorModel.errorType];
                return;
            }
            THToeflDiscoverModel *discoverModel = [THToeflDiscoverModel mj_objectWithKeyValues:response];
            weakSelf.model = discoverModel;
            [weakSelf.tableView ht_endRefreshWithModelArrayCount:1];
            [weakSelf.headerView setModel:weakSelf.model tableView:weakSelf.tableView];
            [weakSelf.tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
                sectionMaker.modelArray(weakSelf.model.Reply);
            }];
        }];
    }];
    [self.tableView ht_startRefreshHeader];
}

- (void)initializeUserInterface {
    __weak THToeflDiscoverDetailController *weakSelf = self;
	UIBarButtonItem *shareBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"Toeflshare"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [THShareView showTitle:weakSelf.model.title detail:weakSelf.model.content image:HTPLACEHOLDERIMAGE url:@"http://bbs.viplgw.cn" type:SSDKContentTypeWebPage];
	}];
	shareBarButtonItem.tintColor = [UIColor whiteColor];
	self.navigationItem.rightBarButtonItems = @[shareBarButtonItem];
	[self.view addSubview:self.tableView];
	[self.view addSubview:self.bottomSpeakView];
    [self ht_addFallowKeyBoardView:self.view style:HTKeyBoardStylePoint customKeyBoardHeight:nil];
	[self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
		make.left.right.mas_equalTo(self.view);
		make.bottom.mas_equalTo(self.bottomSpeakView.mas_top);
	}];
	[self.bottomSpeakView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.left.right.mas_equalTo(self.view);
	}];
	[self.bottomSpeakView.speakTextView bk_addObserverForKeyPath:@"contentSize" options:NSKeyValueObservingOptionInitial task:^(id obj, NSDictionary *change) {
		if (weakSelf.bottomSpeakView.speakTextView.contentSize.height <= 150) {
			[weakSelf.bottomSpeakView mas_updateConstraints:^(MASConstraintMaker *make) {
				make.height.mas_equalTo(weakSelf.bottomSpeakView.speakTextView.contentSize.height + 20);
			}];
		}
	}];
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectZero];
		_tableView.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [[sectionMaker.cellClass([THToeflDiscoverCommentCell class]) customCellBlock:^(UITableView *tableView, NSInteger row, __kindof THToeflDiscoverCommentCell *cell, __kindof THDiscoverReply *model) {
            }] didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof NSObject *model) {
                
            }];
        }];
	}
	return _tableView;
}

- (THToeflDiscoverDetailHeaderView *)headerView {
	if (!_headerView) {
		_headerView = [[THToeflDiscoverDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, 80)];
		
		__weak typeof(self) weakSelf = self;
		[_headerView setCallReplyKeyboard:^{
			[weakSelf.bottomSpeakView becomeFirstResponderWithStyle:THToeflDiscoverDetailSpeakViewEditStyleComment placeHolder:@"我也说一句"];
		}];
	}
	return _headerView;
}

- (THToeflDiscoverDetailSpeakView *)bottomSpeakView {
	if (!_bottomSpeakView) {
        __weak THToeflDiscoverDetailController *weakSelf = self;
		_bottomSpeakView = [[THToeflDiscoverDetailSpeakView alloc] initWithFrame:CGRectZero shouldBeginBlock:^{
			
		} shouldSendBlock:^{
			if (!weakSelf.model) {
				return;
			}
			switch (weakSelf.bottomSpeakView.style) {
				case THToeflDiscoverDetailSpeakViewEditStyleComment: {
                    HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
                    networkModel.autoAlertString = @"回复中";
                    networkModel.offlineCacheStyle = HTCacheStyleNone;
                    networkModel.autoShowError = true;
                    [HTRequestManager requestDiscoverReplyWithNetworkModel:networkModel discoverId:weakSelf.discoverId contentString:weakSelf.bottomSpeakView.speakTextView.text complete:^(id response, HTError *errorModel) {
                        if (errorModel.existError) {
                            return;
                        }
                        weakSelf.bottomSpeakView.speakTextView.text = @"";
						[weakSelf.bottomSpeakView becomeFirstResponderWithStyle:THToeflDiscoverDetailSpeakViewEditStyleComment placeHolder:@"我也说一句"];
                        [weakSelf.bottomSpeakView.speakTextView endEditing:true];
                        [weakSelf.tableView ht_startRefreshHeader];
                    }];
					break;
				}
				case THToeflDiscoverDetailSpeakViewEditStyleSubComment: {
					break;
				}
			}
		}];
	}
	return _bottomSpeakView;
}

@end
