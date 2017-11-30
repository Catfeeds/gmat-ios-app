//
//  HTCourseOrderController.m
//  GMat
//
//  Created by hublot on 2016/11/16.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTCourseOrderController.h"
#import <UITableView+HTSeparate.h>
#import "HTCourseOrderCell.h"
#import "HTCourseOrderModel.h"
#import "HTCourseOrderPayView.h"

@interface HTCourseOrderController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HTCourseOrderModel *orderModel;

@property (nonatomic, strong) HTCourseOrderPayView *orderPayView;

@end

@implementation HTCourseOrderController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
	networkModel.autoAlertString = @"获取订单中";
	networkModel.offlineCacheStyle = HTCacheStyleNone;
	networkModel.autoShowError = true;
	[HTRequestManager requestCoursePayOrderWithNetworkModel:networkModel orderCourseModel:self.courseModel complete:^(id response, HTError *errorModel) {
		if (errorModel.existError) {
			return;
		}
		self.orderModel = [HTCourseOrderModel mj_objectWithKeyValues:response];
		[self.orderPayView setModel:self.orderModel];
		[self.tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
			sectionMaker.modelArray(@[self.orderModel]);
		}];
	}];
}

- (void)initializeUserInterface {
	self.navigationItem.title = @"确认订单";
	[self.view addSubview:self.tableView];
	self.tableView.tableFooterView = [[UIView alloc] init];
	[self.view addSubview:self.orderPayView];
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.ht_w, self.view.ht_h - self.orderPayView.ht_h)];
		_tableView.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [sectionMaker.cellClass([HTCourseOrderCell class])
			 .rowHeight(100) didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof NSObject *model) {
                
            }];
        }];
	}
	return _tableView;
}

- (HTCourseOrderPayView *)orderPayView {
	if (!_orderPayView) {
		_orderPayView = [[HTCourseOrderPayView alloc] initWithFrame:CGRectMake(0, self.view.ht_h - 49, self.view.ht_w, 49)];
		_orderPayView.backgroundColor = [UIColor whiteColor];
	}
	return _orderPayView;
}


@end
