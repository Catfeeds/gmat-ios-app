//
//  HTStoryController.m
//  GMat
//
//  Created by hublot on 2017/8/28.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTStoryController.h"
#import <UITableView+HTSeparate.h>
#import <UIScrollView+HTRefresh.h>
#import "HTStoryModel.h"
#import "HTStoryCell.h"
#import "HTStoryDetailController.h"
#import "HTStoryHeaderView.h"

@interface HTStoryController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HTStoryHeaderView *headerView;

@property (nonatomic, strong) NSMutableArray *modelArray;

@end

@implementation HTStoryController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
	__weak typeof(self) weakSelf = self;
	[self.tableView ht_setRefreshBlock:^(NSString *pageSize, NSString *currentPage) {
		HTNetworkModel *networkModel = [HTNetworkModel modelForOnlyCacheNoInterfaceForScrollViewWithCacheStyle:HTCacheStyleAllUser];
		[HTRequestManager requestStoryListWithNetworkModel:networkModel pageSize:pageSize currentPage:currentPage complete:^(id response, HTError *errorModel) {
			if (errorModel.existError) {
				[weakSelf.tableView ht_endRefreshWithModelArrayCount:errorModel.errorType];
				return;
			}
			NSMutableArray *modelArray = [HTStoryModel mj_objectArrayWithKeyValuesArray:response[@"lidata"]];
			[weakSelf.tableView ht_endRefreshWithModelArrayCount:modelArray.count];
			if (currentPage.integerValue <= 1) {
				weakSelf.modelArray = modelArray;
			} else {
				[weakSelf.modelArray addObjectsFromArray:modelArray];
			}
			[weakSelf.tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
				sectionMaker.modelArray(weakSelf.modelArray);
			}];
		}];
	}];
	[self.tableView ht_startRefreshHeader];
}

- (void)initializeUserInterface {
	[self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 49)];
		_tableView.backgroundColor = [UIColor ht_colorString:@"e0e0e0"];
		_tableView.separatorColor = _tableView.backgroundColor;
        
        __weak typeof(self) weakSelf = self;
		[_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
			[sectionMaker.cellClass([HTStoryCell class]).rowHeight(110) didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof HTStoryModel *model) {
				HTStoryDetailController *detailController = [[HTStoryDetailController alloc] init];
                detailController.storyIdString = model.contentid;
                [weakSelf.navigationController pushViewController:detailController animated:true];
			}];
		}];
	}
	return _tableView;
}

- (HTStoryHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[HTStoryHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, 180)];
    }
    return _headerView;
}


@end
