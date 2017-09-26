//
//  HTReportSingleController.m
//  GMat
//
//  Created by hublot on 16/11/30.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTReportSingleController.h"
#import <UITableView+HTSeparate.h>
#import "HTReportLineTableView.h"
#import "HTReportExerciseHeaderView.h"
#import "HTReportExerciseCircleView.h"
#import "HTReportSingleFirstCell.h"
#import "HTReportSingleSecondCell.h"
#import "HTReportSingleThirdCell.h"
#import "HTReportSingleFourthCell.h"

@interface HTReportSingleController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HTReportSingleController

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)setReportModel:(HTReportModel *)reportModel {
	_reportModel = reportModel;
	if (_reportModel) {
		for (NSInteger index = 0; index < 4; index ++) {
			__weak HTReportSingleController *weakSelf = self;
			[self.tableView ht_updateSection:index sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
				sectionMaker.modelArray(@[weakSelf.reportModel]);
			}];
		}
	}
}

- (void)initializeUserInterface {
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(notificationOrientationReloadData)
												 name:UIApplicationDidChangeStatusBarOrientationNotification
											   object:nil];

	[self.view addSubview:self.tableView];
    self.automaticallyAdjustsScrollViewInsets = false;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)notificationOrientationReloadData {
	[self.tableView reloadData];
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
		_tableView.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_tableView.allowsSelection = false;
		
		__weak HTReportSingleController *weakSelf = self;
        [_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [sectionMaker.cellClass([HTReportSingleFirstCell class])
			 .headerHeight(50)
			 .headerView([HTReportExerciseHeaderView headerViewTitle:@"备考数据"]) customCellBlock:^(UITableView *tableView, NSInteger row, __kindof HTReportSingleFirstCell *cell, __kindof NSObject *model) {
                cell.reportStyle = weakSelf.reportStyle;
            }];
        }];
        [_tableView ht_updateSection:1 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [sectionMaker.cellClass([HTReportSingleSecondCell class])
			 .rowHeight(160)
			 .headerHeight(50)
			 .headerView([HTReportExerciseHeaderView headerViewTitle:@"你目前的难度水平"]) customCellBlock:^(UITableView *tableView, NSInteger row, __kindof HTReportSingleSecondCell *cell, __kindof NSObject *model) {
                cell.reportStyle = weakSelf.reportStyle;
            }];
        }];
        [_tableView ht_updateSection:2 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [sectionMaker.cellClass([HTReportSingleThirdCell class])
			 .rowHeight(80)
			 .headerHeight(50)
			 .headerView([HTReportExerciseHeaderView headerViewTitle:@"整体复习状态"]) customCellBlock:^(UITableView *tableView, NSInteger row, __kindof HTReportSingleThirdCell *cell, __kindof NSObject *model) {
                cell.reportStyle = weakSelf.reportStyle;
            }];
        }];
        [_tableView ht_updateSection:3 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [sectionMaker.cellClass([HTReportSingleFourthCell class])
			 .headerHeight(50)
			 .headerView([HTReportExerciseHeaderView headerViewTitle:@"复习策略建议"]) customCellBlock:^(UITableView *tableView, NSInteger row, __kindof HTReportSingleFourthCell *cell, __kindof NSObject *model) {
                cell.reportStyle = weakSelf.reportStyle;
            }];
        }];
    }
	return _tableView;
}


@end
