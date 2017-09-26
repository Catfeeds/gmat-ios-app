//
//  HTReportSumController.m
//  GMat
//
//  Created by hublot on 16/11/30.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTReportSumController.h"
#import <UITableView+HTSeparate.h>
#import "HTReportLineTableView.h"
#import "HTReportExerciseHeaderView.h"
#import "HTReportExerciseCircleView.h"
#import "HTReportSingleFirstCell.h"
#import "HTReportSingleSecondCell.h"
#import "HTReportSingleThirdCell.h"
#import "HTReportSingleFourthCell.h"
#import "HTReportExcelCollectionCell.h"
#import "HTReportSumTableCell.h"
#import "HTReportSumCircelCell.h"
#import "HTReportSumDetailCell.h"

@interface HTReportSumController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger firstSegmentedIndex;

@property (nonatomic, assign) NSInteger secondSegmentedIndex;

@end

@implementation HTReportSumController

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

- (void)setReportModel:(HTReportModel *)reportModel {
	_reportModel = reportModel;
	if (_reportModel) {
		for (NSInteger index = 0; index < 7; index ++) {
			
			__weak HTReportSumController *weakSelf = self;
			[self.tableView ht_updateSection:index sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
				sectionMaker.modelArray(@[weakSelf.reportModel]);
			}];
		}
	}
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
		
		__weak HTReportSumController *weakSelf = self;
        [_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [sectionMaker.cellClass([HTReportExcelCollectionCell class])
			 .headerHeight(50)
			 .headerView([HTReportExerciseHeaderView headerViewTitle:@"Verbal部分"]) customCellBlock:^(UITableView *tableView, NSInteger row, __kindof HTReportExcelCollectionCell *cell, __kindof NSObject *model) {
                cell.collectionExcelType = collectionExcelTypeThreeColFourRow;
            }];
        }];
        [_tableView ht_updateSection:1 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [sectionMaker.cellClass([HTReportSumTableCell class])
			 .headerHeight(50)
			 .headerView([HTReportExerciseHeaderView headerViewTitle:@"考点掌握分析"]) customCellBlock:^(UITableView *tableView, NSInteger row, __kindof HTReportSumTableCell *cell, __kindof NSObject *model) {
                cell.segmentedControl.selectedSegmentIndex = weakSelf.firstSegmentedIndex;
                
                __weak HTReportSumTableCell *weakCell = cell;
                [cell.segmentedControl bk_addObserverForKeyPath:@"selectedSegmentIndex" options:NSKeyValueObservingOptionNew task:^(id obj, NSDictionary *change) {
                    if (weakCell.segmentedControl.selectedSegmentIndex != weakSelf.firstSegmentedIndex) {
                        weakSelf.firstSegmentedIndex = weakCell.segmentedControl.selectedSegmentIndex;
                        weakSelf.reportModel = weakSelf.reportModel;
                    }
                }];
            }];
        }];
        [_tableView ht_updateSection:2 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [sectionMaker.cellClass([HTReportExcelCollectionCell class])
			 .headerHeight(50)
			 .headerView([HTReportExerciseHeaderView headerViewTitle:@"难度水平"]) customCellBlock:^(UITableView *tableView, NSInteger row, __kindof HTReportExcelCollectionCell *cell, __kindof NSObject *model) {
                cell.collectionExcelType = collectionExcelTypeFiveColFourRow;
            }];
        }];
        [_tableView ht_updateSection:3 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [sectionMaker.cellClass([HTReportSumCircelCell class])
			 .headerHeight(50)
			 .headerView([HTReportExerciseHeaderView headerViewTitle:@"QUANT部分"]) customCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof NSObject *model) {
            }];
        }];
        [_tableView ht_updateSection:4 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [sectionMaker.cellClass([HTReportSingleSecondCell class])
			 .rowHeight(160)
			 .headerHeight(50)
			 .headerView([HTReportExerciseHeaderView headerViewTitle:@"你目前的难度水平"]) customCellBlock:^(UITableView *tableView, NSInteger row, __kindof HTReportSingleSecondCell *cell, __kindof NSObject *model) {
                cell.reportStyle = weakSelf.reportStyle;
            }];
        }];
        [_tableView ht_updateSection:5 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [sectionMaker.cellClass([HTReportSingleThirdCell class])
			 .rowHeight(80)
			 .headerHeight(50)
			 .headerView([HTReportExerciseHeaderView headerViewTitle:@"整体复习状态"]) customCellBlock:^(UITableView *tableView, NSInteger row, __kindof HTReportSingleThirdCell *cell, __kindof NSObject *model) {
                cell.reportStyle = weakSelf.reportStyle;
            }];
        }];
        [_tableView ht_updateSection:6 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [sectionMaker.cellClass([HTReportSumDetailCell class])
			 .headerHeight(50)
			 .headerView([HTReportExerciseHeaderView headerViewTitle:@"复习策略建议"]) customCellBlock:^(UITableView *tableView, NSInteger row, __kindof HTReportSumDetailCell *cell, __kindof NSObject *model) {
                cell.segmentedControl.selectedSegmentIndex = weakSelf.secondSegmentedIndex;
                
                __weak HTReportSumDetailCell *weakCell = cell;
                [cell.segmentedControl bk_addObserverForKeyPath:@"selectedSegmentIndex" options:NSKeyValueObservingOptionNew task:^(id obj, NSDictionary *change) {
                    if (weakCell.segmentedControl.selectedSegmentIndex != weakSelf.secondSegmentedIndex) {
                        weakSelf.secondSegmentedIndex = weakCell.segmentedControl.selectedSegmentIndex;
                        weakSelf.reportModel = weakSelf.reportModel;
                    }
                }];
            }];
        }];
	}
	return _tableView;
}

@end
