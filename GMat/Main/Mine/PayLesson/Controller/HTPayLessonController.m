//
//  HTPayLessonController.m
//  GMat
//
//  Created by hublot on 2016/10/19.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTPayLessonController.h"
#import "HTPayLessonReuseController.h"
#import "HTCourseOnlineVideoModel.h"

@interface HTPayLessonController ()

@end

@implementation HTPayLessonController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	self.navigationItem.title = @"购课记录";
	NSArray *titleArray = @[@"公开课", @"收费课"];
	NSMutableArray *pageModelArray = [@[] mutableCopy];
	[titleArray enumerateObjectsUsingBlock:^(NSString *title, NSUInteger index, BOOL * _Nonnull stop) {
		HTPageModel *pageModel = [[HTPageModel alloc] init];
		pageModel.selectedTitle = title;
		pageModel.reuseControllerClass = [HTPayLessonReuseController class];
		[pageModelArray addObject:pageModel];
	}];
	self.pageModelArray = pageModelArray;
	[self setModelArrayBlock:^(NSString *pageIndex, NSString *pageCount, NSString *currentPage, void (^modelArrayStatus)(NSArray<HTCourseOnlineVideoModel *> *, HTError *)) {
		HTNetworkModel *networkModel = [HTNetworkModel modelForOnlyCacheNoInterfaceForScrollViewWithCacheStyle:HTCacheStyleSingleUser];
		[HTRequestManager requestCourseRecordWithNetworkModel:networkModel courseRecordStyle:pageIndex.integerValue pageSize:pageCount currentPage:currentPage complete:^(id response, HTError *errorModel) {
			if (errorModel.existError) {
				modelArrayStatus(nil, errorModel);
				return;
			}
			modelArrayStatus(@[], nil);
		}];
	}];
	[self.magicView reloadData];
}


@end
