//
//  THCourseTogetherController.m
//  TingApp
//
//  Created by hublot on 16/8/22.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "THCourseTogetherController.h"
#import <UITableView+HTSeparate.h>
#import "THTogetherTeacherCell.h"
#import "THCourseTeacherDetailController.h"
#import "UIScrollView+HTRefresh.h"
#import "THTeacherDetailAlertView.h"

@interface THCourseTogetherController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *modelArray;

@end

@implementation THCourseTogetherController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
    __weak THCourseTogetherController *weakSelf = self;
	[self.tableView ht_setRefreshBlock:^(NSString *pageSize, NSString *currentPage) {
		HTNetworkModel *networkModel = [HTNetworkModel modelForOnlyCacheNoInterfaceForScrollViewWithCacheStyle:HTCacheStyleAllUser];
		[HTRequestManager requestTeacherListWithNetworkModel:networkModel complete:^(id response, HTError *errorModel) {
			if (errorModel.existError) {
				[weakSelf.tableView ht_endRefreshWithModelArrayCount:errorModel.errorType];
				return;
			}
			NSMutableArray *modelArray = [THCourseTogetherTeacherModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
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
	self.navigationItem.title = @"约课";
	[self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        __weak THCourseTogetherController *weakSelf = self;
        
        [_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [[sectionMaker.cellClass([THTogetherTeacherCell class])
			  .rowHeight(HTADAPT568(110)) didSelectedCellBlock:^(UITableView *tableView, NSInteger row, UITableViewCell *cell, THCourseTogetherTeacherModel *model) {
                THCourseTeacherDetailController *detailController = [[THCourseTeacherDetailController alloc] init];
                detailController.model = model;
                [weakSelf.navigationController pushViewController:detailController animated:true];
            }] customCellBlock:^(UITableView *tableView, NSInteger row, __kindof THTogetherTeacherCell *cell, __kindof THCourseTogetherTeacherModel *model) {
                [cell.inviteButton ht_whenTap:^(UIView *view) {
                    [THCourseTeacherDetailController invideButtonTeapedWithModel:model complete:^{
						
					}];
                }];
            }];
        }];
		_tableView.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	}
	return _tableView;
}


@end
