//
//  HTKnowledgeController.m
//  GMat
//
//  Created by hublot on 16/10/12.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTKnowledgeController.h"
#import <UITableView+HTSeparate.h>
#import "HTKnowledgeCell.h"
#import "HTKnowledgeModel.h"
#import "HTKnowledgeCategoryController.h"
#import "HTNavigationBar.h"
#import "UIScrollView+HTRefresh.h"

@interface HTKnowledgeController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HTKnowledgeController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if (!self.tableView.visibleCells.count) {
		[self.tableView ht_startRefreshHeader];
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
	networkModel.autoAlertString = nil;
	networkModel.offlineCacheStyle = HTCacheStyleAllUser;
	networkModel.autoShowError = false;
	
	__weak HTKnowledgeController *weakSelf = self;
	[self.tableView ht_setRefreshBlock:^(NSString *pageSize, NSString *currentPage) {
		[HTRequestManager requestKnowledgeListWithNetworkModel:networkModel complete:^(id response, HTError *errorModel) {
			if (errorModel.existError) {
				[weakSelf.tableView ht_endRefreshWithModelArrayCount:errorModel.errorType];
				return;
			}
			NSArray *modelArray = [HTKnowledgeModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
			[weakSelf.tableView ht_endRefreshWithModelArrayCount:modelArray.count];
			[weakSelf.tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
				sectionMaker.modelArray(modelArray);
			}];
		}];
	}];
}

- (void)initializeUserInterface {
	[self.view addSubview:self.tableView];
	self.navigationItem.title = @"小讲堂";
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [sectionMaker.cellClass([HTKnowledgeCell class])
			 .rowHeight((_tableView.ht_h - 64 - 49) / 4.0) didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof NSObject *model) {
                HTKnowledgeCategoryController *categoryController = [[HTKnowledgeCategoryController alloc] init];
                UIColor *cellBackgroundColor = @[[UIColor ht_colorString:@"2a5b91"], [UIColor ht_colorString:@"fd8330"], [UIColor ht_colorString:@"8487be"], [UIColor ht_colorString:@"599f8c"]][row];
                categoryController.knowledgeModel = model;
                [categoryController.knowledgeModel.categoryType enumerateObjectsUsingBlock:^(KnowledgeCategorytype * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.cellBackgroundColor = cellBackgroundColor;
                }];
                [self.navigationController pushViewController:categoryController animated:true];
            }];
        }];
	}
	return _tableView;
}


@end
