//
//  HTPointExerciseController.m
//  GMat
//
//  Created by hublot on 2016/10/18.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTPointExerciseController.h"
#import "HTSingleExerciseContentController.h"
#import "UIScrollView+HTRefresh.h"
#import "HTExerciseModel.h"
#import "HTQuestionManager.h"
#import "HTManagerController+HTRotate.h"

@interface HTPointExerciseController () <HTRotateVisible, HTRotateEveryOne>

@end

@implementation HTPointExerciseController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	self.navigationItem.title = @"知识点练习";
	NSArray *titleArray = @[@"SC", @"CR", @"RC", @"PS", @"DS"];
	NSArray *sectionIdArray = @[@"6", @"8", @"7", @"4", @"5"];
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
		NSString *sectionid = sectionIdArray[pageIndex.integerValue];
		NSMutableArray <HTExerciseModel *> *modelArray = [HTQuestionManager packPointExerciseModelArrayWithSectionId:sectionid];
		[modelArray enumerateObjectsUsingBlock:^(HTExerciseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			obj.modelStyle = HTExerciseModelStylePoint;
		}];
		modelArrayStatus(modelArray, nil);
	}];
	[self.magicView reloadData];
}

@end
