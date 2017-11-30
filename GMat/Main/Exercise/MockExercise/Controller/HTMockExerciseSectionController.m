//
//  HTMockExerciseSectionController.m
//  GMat
//
//  Created by hublot on 2016/10/26.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTMockExerciseSectionController.h"
#import "HTSingleExerciseContentController.h"
#import "UIScrollView+HTRefresh.h"
#import "HTExerciseModel.h"

@interface HTMockExerciseSectionController ()

@property (nonatomic, strong) NSMutableDictionary <NSString *, NSMutableArray *> *pageDictionary;

@property (nonatomic, strong) NSMutableDictionary *currentPageDictionary;

@end

@implementation HTMockExerciseSectionController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	self.navigationItem.title = self.mockExerciseString;
	__weak HTMockExerciseSectionController *weakSelf = self;
	NSArray *titleArray = @[@"PREP", @"GWD", @"精选题库"];
	NSMutableArray *pageModelArray = [@[] mutableCopy];
	[titleArray enumerateObjectsUsingBlock:^(NSString *title, NSUInteger index, BOOL * _Nonnull stop) {
		HTPageModel *pageModel = [[HTPageModel alloc] init];
		pageModel.selectedTitle = title;
		pageModel.reuseControllerClass = [HTSingleExerciseContentController class];
		[pageModelArray addObject:pageModel];
	}];
	self.pageModelArray = pageModelArray;
	[self setModelArrayBlock:^(NSString *pageIndex, NSString *pageCount, NSString *currentPage, void (^modelArrayStatus)(NSArray <HTExerciseModel *> *, HTError *)) {
		if (currentPage.integerValue > 1) {
			modelArrayStatus(@[], nil);
			return;
		}
		HTNetworkModel *networkModel = [HTNetworkModel modelForOnlyCacheNoInterfaceForScrollViewWithCacheStyle:HTCacheStyleSingleUser];
		[HTRequestManager requestMockListWithNetworkModel:networkModel mockStyle:weakSelf.mockStyle typeClass:pageIndex.integerValue complete:^(id response, HTError *errorModel) {
			if (errorModel.existError) {
				modelArrayStatus(nil, errorModel);
				return;
			}
			NSMutableArray <HTExerciseModel *> *modelArray = [HTExerciseModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
			[modelArray enumerateObjectsUsingBlock:^(HTExerciseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
				obj.modelStyle = HTExerciseModelStyleMock;
				obj.mockStartType = weakSelf.mockStyle + 1;
			}];
			modelArrayStatus(modelArray, nil);
		}];
	}];
	[self.magicView reloadData];
}

@end
