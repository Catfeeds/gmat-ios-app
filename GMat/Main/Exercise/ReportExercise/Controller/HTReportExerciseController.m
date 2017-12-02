//
//  HTReportExerciseController.m
//  GMat
//
//  Created by hublot on 2016/10/18.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTReportExerciseController.h"
#import "HTLoginManager.h"
#import "HTReportDropMenuButton.h"
#import "HTReportSingleController.h"
#import "HTReportSumController.h"
#import "HTReportModel.h"
#import "UIScrollView+HTRefresh.h"
#import "HTManagerController+HTRotate.h"

@interface HTReportExerciseController () <HTRotateVisible, HTRotateEveryOne>

@property (nonatomic, strong) HTReportDropMenuButton *dropMenuButton;

@property (nonatomic, strong) UIViewController *childController;

@property (nonatomic, strong) HTReportModel *reportModel;

@end

@implementation HTReportExerciseController

- (void)dealloc {
    
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)appendTableViewRefreshBlockWithTableView:(UITableView *)tableView {
	__weak UITableView *weakTableView = tableView;
	__weak HTReportExerciseController *weakSelf = self;
	[tableView ht_setRefreshBlock:^(NSString *pageSize, NSString *currentPage) {
		if (weakSelf.reportModel) {
			[weakSelf fillDataToChildControllerTabelView:weakTableView];
			return;
		}
		HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
		networkModel.autoAlertString = nil;
		networkModel.offlineCacheStyle = HTCacheStyleSingleUser;
		networkModel.autoShowError = false;
		[HTRequestManager requestStudyReportWithNetworkModel:networkModel complete:^(id response, HTError *errorModel) {
			if (errorModel.existError) {
				[weakTableView ht_endRefreshWithModelArrayCount:errorModel.errorType];
				return;
			}
			weakSelf.reportModel = [HTReportModel mj_objectWithKeyValues:response[@"data"]];
			[weakSelf fillDataToChildControllerTabelView:weakTableView];
		}];
	}];

}

- (void)fillDataToChildControllerTabelView:(UITableView *)tableView {
	[self.childController setValue:self.reportModel forKey:@"reportModel"];
	[tableView ht_endRefreshWithModelArrayCount:1];
}

- (void)initializeUserInterface {
	self.navigationItem.titleView = self.dropMenuButton;
    self.automaticallyAdjustsScrollViewInsets = false;
}

- (HTReportDropMenuButton *)dropMenuButton {
	if (!_dropMenuButton) {
        __weak HTReportExerciseController *weakSelf = self;
		_dropMenuButton = [[HTReportDropMenuButton alloc] initWithTitleArray:@[@"Complete Report", @"SC Report", @"RC Report", @"CR Report", @"Quant Report"] selectedBlock:^(NSInteger index) {
			[weakSelf.childController.view removeFromSuperview];
			[weakSelf.childController willMoveToParentViewController:nil];
			[weakSelf.childController removeFromParentViewController];
			if (!index) {
				weakSelf.childController = [[HTReportSumController alloc] init];
			} else {
				weakSelf.childController = [[HTReportSingleController alloc] init];
			}
			[weakSelf.childController setValue:@(index) forKey:@"reportStyle"];
			[weakSelf.view addSubview:weakSelf.childController.view];
			[weakSelf addChildViewController:weakSelf.childController];
			[weakSelf.childController willMoveToParentViewController:weakSelf];
			
			UITableView *tableView = [weakSelf.childController valueForKey:@"tableView"];
			[weakSelf appendTableViewRefreshBlockWithTableView:tableView];
			[tableView ht_startRefreshHeader];
		}];
		_dropMenuButton.frame = CGRectMake(0, 0, HTADAPT568(200), 44);
	}
	return _dropMenuButton;
}


@end
