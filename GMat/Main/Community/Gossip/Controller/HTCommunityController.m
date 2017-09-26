//
//  HTCommunityController.m
//  GMat
//
//  Created by hublot on 2016/10/26.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTCommunityController.h"
#import "HTCommunityIssueController.h"
#import "HTLoginManager.h"
#import "HTCommunityLayoutModel.h"
#import "HTCommunityCell.h"
#import <UITableView+HTSeparate.h>
#import "UIScrollView+HTRefresh.h"
#import "HTCommunityDetailController.h"
#import "HTCommunityMessageController.h"
#import <UITableViewCell_HTSeparate.h>
#import <NSObject+HTTableRowHeight.h>
#import "HTMineFontSizeController.h"

@interface HTCommunityController ()

@property (nonatomic, strong) NSMutableArray <HTCommunityLayoutModel *> *communityLayoutModelArray;

@end

@implementation HTCommunityController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	self.tableView.ht_pageSize = 20;
	
	__weak HTCommunityController *weakSelf = self;
	[self.tableView ht_setRefreshBlock:^(NSString *pageSize, NSString *currentPage) {
		HTNetworkModel *networkModel = [HTNetworkModel modelForOnlyCacheNoInterfaceForScrollViewWithCacheStyle:HTCacheStyleAllUser];
		[HTRequestManager requestGossipListWithNetworkModel:networkModel pageSize:pageSize currentPage:currentPage complete:^(id response, HTError *errorModel) {
			if (errorModel.existError) {
				[weakSelf.tableView ht_endRefreshWithModelArrayCount:errorModel.errorType];
				return;
			}
			dispatch_async(dispatch_get_global_queue(0, 0), ^{
				NSMutableArray <HTCommunityLayoutModel *> *communityLayoutModelArray = [@[] mutableCopy];
				if (response && response[@"data"] && response[@"data"][@"data"]) {
					NSMutableArray <HTCommunityModel *> *communityModelArray = [HTCommunityModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"data"]];
					[communityModelArray enumerateObjectsUsingBlock:^(HTCommunityModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
						HTCommunityLayoutModel *communityLayoutModel = [HTCommunityLayoutModel layoutModelWithOriginModel:obj isDetail:false];
						[communityLayoutModelArray addObject:communityLayoutModel];
					}];
					NSInteger ringCount = [response[@"num"] integerValue];
					dispatch_async(dispatch_get_main_queue(), ^{
						[weakSelf.communityHeaderView setRingCount:ringCount completeBlock:^{
							weakSelf.tableView.tableHeaderView = weakSelf.communityHeaderView;
						}];
					});
				}
				if (currentPage.integerValue == 1) {
					weakSelf.communityLayoutModelArray = communityLayoutModelArray;
				} else {
					[weakSelf.communityLayoutModelArray addObjectsFromArray:communityLayoutModelArray];
				}
				dispatch_async(dispatch_get_main_queue(), ^{
					[weakSelf.tableView ht_endRefreshWithModelArrayCount:communityLayoutModelArray.count];
					[weakSelf.tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
						sectionMaker.modelArray(weakSelf.communityLayoutModelArray);
					}];
				});
			});
		}];
	}];
	[self.tableView ht_startRefreshHeader];
	
	[[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(ht_startRefreshHeader) name:kHTFontChangeNotification object:nil];
	
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
		_tableView.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [sectionMaker.cellClass([HTCommunityCell class]) didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof HTCommunityLayoutModel *model) {
                HTCommunityDetailController *detailController = [[HTCommunityDetailController alloc] init];
                [detailController setDetailDidDismissBlock:^(HTCommunityModel *communityModel) {
                    HTCommunityLayoutModel *communityLayoutModel = [HTCommunityLayoutModel layoutModelWithOriginModel:communityModel isDetail:false];
                    [self.communityLayoutModelArray replaceObjectAtIndex:row withObject:communityLayoutModel];
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [cell setModel:communityLayoutModel row:row];
                            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                        });
                    });
                }];
                detailController.communityIdString = model.originModel.Id;
                [self.navigationController pushViewController:detailController animated:true];
            }];
        }];
	}
	return _tableView;
}

- (HTCommunityRingHeaderView *)communityHeaderView {
	if (!_communityHeaderView) {
		_communityHeaderView = [[HTCommunityRingHeaderView alloc] init];
		[_communityHeaderView.communityRingView ht_whenTap:^(UIView *view) {
			HTCommunityMessageController *messageController = [[HTCommunityMessageController alloc] init];
			[self.navigationController pushViewController:messageController animated:true];
		}];
	}
	return _communityHeaderView;
}

@end
