//
//  HTOpenController.m
//  GMat
//
//  Created by hublot on 16/10/13.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTOpenController.h"
#import <UITableView+HTSeparate.h>
#import "UIScrollView+HTRefresh.h"
#import "HTOpenCell.h"
#import "HTCourseOpenModel.h"
#import "HTOpenDetailController.h"

@interface HTOpenController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <HTCourseOpenModel *> *modelArray;

@end

@implementation HTOpenController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
    __weak HTOpenController *weakSelf = self;
	[self.tableView ht_setRefreshBlock:^(NSString *pageSize, NSString *currentPage) {
		HTNetworkModel *networkModel = [HTNetworkModel modelForOnlyCacheNoInterfaceForScrollViewWithCacheStyle:HTCacheStyleAllUser];
		[HTRequestManager requestOpenCourseWithNetworkModel:networkModel complete:^(id response, HTError *errorModel) {
			if (errorModel.existError) {
				[weakSelf.tableView ht_endRefreshWithModelArrayCount:errorModel.errorType];
				return;
			}
			NSMutableArray *modelArray = [HTCourseOpenModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
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
	self.navigationItem.title = @"公开课";
	[self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_tableView.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
        __weak HTOpenController *weakSelf = self;
        
        [_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [sectionMaker.cellClass([HTOpenCell class])
			 .rowHeight(90) didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof HTCourseOpenModel *model) {
                HTOpenDetailController *openDetailController = [[HTOpenDetailController alloc] init];
                openDetailController.courseModel = model;
                [weakSelf.navigationController pushViewController:openDetailController animated:true];
            }];
        }];
	}
	return _tableView;
}

- (NSMutableArray<HTCourseOpenModel *> *)modelArray {
	if (!_modelArray) {
		_modelArray = [@[] mutableCopy];
	}
	return _modelArray;
}

@end
