//
//  HTOnlineDetailController.m
//  GMat
//
//  Created by hublot on 16/10/17.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTOnlineDetailController.h"
#import "THTableButton.h"
#import <UITableView+HTSeparate.h>
#import "HTCourseOnlineVideoModel.h"
#import "HTOpenDetailHeaderView.h"
#import "HTCourseTitleDetailModel.h"
#import "HTCourseTitleDetailCell.h"
#import "HTLoginManager.h"
#import "HTCourseOrderController.h"
//#import <JSPatchPlatform/JSPatch.h>
#import "HTManagerController.h"

@interface HTOnlineDetailController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HTOpenDetailHeaderView *tableHeaderView;

@property (nonatomic, strong) THTableButton *payButton;

@end

@implementation HTOnlineDetailController

- (void)dealloc {
    
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	HTCourseTitleDetailModel *courseModel = [[HTCourseTitleDetailModel alloc] init];
	courseModel.titleName = @"课程详情";
    courseModel.detailName = self.courseModel.contenttext;
	[self.tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
		sectionMaker.modelArray(@[courseModel]);
	}];
	[self.tableHeaderView setModel:self.courseModel row:0];
}

- (void)initializeUserInterface {
	self.navigationItem.title = @"课程详情";
	[self.view addSubview:self.tableView];
	[self.view addSubview:self.payButton];
    self.automaticallyAdjustsScrollViewInsets = false;
	if (@available(iOS 11.0, *)) {
		self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.ht_w, self.view.ht_h - self.payButton.ht_h)];
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
		_tableView.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_tableView.allowsSelection = false;
        
        __weak HTOnlineDetailController *weakSelf = self;
        [_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            sectionMaker.cellClass([HTCourseTitleDetailCell class])
			.headerView(weakSelf.tableHeaderView)
			.headerHeight(weakSelf.tableHeaderView.ht_h);
        }];
	}
	return _tableView;
}

- (HTOpenDetailHeaderView *)tableHeaderView {
	if (!_tableHeaderView) {
		_tableHeaderView = [[HTOpenDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.ht_w, 150)];
	}
	return _tableHeaderView;
}

- (THTableButton *)payButton {
	if (!_payButton) {
		_payButton = [[THTableButton alloc] initWithFrame:CGRectMake(0, self.view.ht_h - 49, self.view.ht_w, [self.class hiddenPayLessonButton] ? 0 : 49)];
		[_payButton setTitle:@"立即下单" forState:UIControlStateNormal];
        _payButton.clipsToBounds = true;
        
        __weak HTOnlineDetailController *weakSelf = self;
		[_payButton ht_whenTap:^(UIView *view) {
			[HTUserManager surePermissionHighOrEqual:HTUserPermissionExerciseAbleUser passCompareBlock:^(HTUser *user) {
				HTCourseOrderController *courseOrderController = [[HTCourseOrderController alloc] init];
				[MTA trackCustomKeyValueEvent:@"creatCourseOrder" props:weakSelf.courseModel.mj_keyValues];
				courseOrderController.courseModel = weakSelf.courseModel;
				[weakSelf.navigationController pushViewController:courseOrderController animated:true];
			}];
		}];
	}
	return _payButton;
}

+ (BOOL)hiddenPayLessonButton {
	return true;
//    if ([[JSPatch getConfigParam:@"autoHiddenByVersion"] boolValue]) {
//        return ![HTManagerController defaultManagerController].managerModel.isAppStorePassReviewVersion;
//    } else {
//        return [[JSPatch getConfigParam:@"orderButtonHidden"] boolValue];
//    }
}

+ (BOOL)hiddenCourcePriceTag {
	return true;
//    if ([[JSPatch getConfigParam:@"autoHiddenByVersion"] boolValue]) {
//        return ![HTManagerController defaultManagerController].managerModel.isAppStorePassReviewVersion;
//    } else {
//        return [[JSPatch getConfigParam:@"priceTagHidden"] boolValue];
//    }
}

@end
