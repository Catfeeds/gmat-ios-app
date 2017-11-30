//
//  HTMockRecordController.m
//  GMat
//
//  Created by hublot on 2016/10/19.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTMockRecordController.h"
#import "HTMockRecordReuseController.h"
#import "HTMockRecordModel.h"
#import "HTManagerController+HTRotate.h"

@interface HTMockRecordController () <HTRotateVisible, HTRotateEveryOne>

@end

@implementation HTMockRecordController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	self.navigationItem.title = @"模考记录";
	NSArray *titleArray = @[@"语文套题", @"数学套题", @"全套模考"];
	NSMutableArray *pageModelArray = [@[] mutableCopy];
	[titleArray enumerateObjectsUsingBlock:^(NSString *title, NSUInteger index, BOOL * _Nonnull stop) {
		HTPageModel *pageModel = [[HTPageModel alloc] init];
		pageModel.selectedTitle = title;
		pageModel.reuseControllerClass = [HTMockRecordReuseController class];
		[pageModelArray addObject:pageModel];
	}];
	self.pageModelArray = pageModelArray;
	[self setModelArrayBlock:^(NSString *pageIndex, NSString *pageCount, NSString *currentPage, void (^modelArrayStatus)(NSArray<HTMockRecordModel *> *, HTError *)) {
		HTNetworkModel *networkModel = [HTNetworkModel modelForOnlyCacheNoInterfaceForScrollViewWithCacheStyle:HTCacheStyleSingleUser];
		[HTRequestManager requestMockRecordWithNetworkModel:networkModel mockStyle:pageIndex.integerValue pageSize:pageCount currentPage:currentPage complete:^(id response, HTError *errorModel) {
			if (errorModel.existError) {
				modelArrayStatus(nil, errorModel);
				return;
			}
			NSMutableArray <HTMockRecordModel *> *modelArray = [HTMockRecordModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
			modelArrayStatus(modelArray, nil);
		}];
	}];
	[self.magicView reloadData];
}

- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof HTMockRecordReuseController *)viewController atPage:(NSUInteger)pageIndex {
	[super magicView:magicView viewDidAppear:viewController atPage:pageIndex];
	viewController.mockStartType = pageIndex + 1;
}

@end
