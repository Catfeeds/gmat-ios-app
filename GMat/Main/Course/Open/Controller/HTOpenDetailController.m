//
//  HTOpenDetailController.m
//  GMat
//
//  Created by hublot on 16/10/14.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTOpenDetailController.h"
#import "THTableButton.h"
#import <UITableView+HTSeparate.h>
#import "HTCourseOnlineVideoModel.h"
#import "HTOpenDetailHeaderView.h"
#import "HTCourseTitleDetailModel.h"
#import "HTCourseTitleDetailCell.h"

@interface HTOpenDetailController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HTOpenDetailHeaderView *tableHeaderView;

//@property (nonatomic, strong) THTableButton *payButton;

@end

@implementation HTOpenDetailController

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
	courseModel.detailName = self.courseModel.sentenceNumber;
	[self.tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
		sectionMaker.modelArray(@[courseModel]);
	}];
    [self.tableHeaderView setModel:self.courseModel row:0];
}

- (void)initializeUserInterface {
	self.navigationItem.title = @"公开课详情";
	[self.view addSubview:self.tableView];
    self.automaticallyAdjustsScrollViewInsets = false;
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
		_tableView.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_tableView.allowsSelection = false;
        
        __weak HTOpenDetailController *weakSelf = self;
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


//- (THTableButton *)payButton {
//	if (!_payButton) {
//		_payButton = [[THTableButton alloc] initWithFrame:CGRectMake(0, self.view.h - 49, self.view.w, 49)];
//		[_payButton setTitle:@"立即报名" forState:UIControlStateNormal];
//	}
//	return _payButton;
//}

@end
