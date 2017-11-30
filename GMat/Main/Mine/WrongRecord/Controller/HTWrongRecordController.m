//
//  HTWrongRecordController.m
//  GMat
//
//  Created by hublot on 2016/10/19.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTWrongRecordController.h"
#import "HTWrongRecordReuseController.h"
#import "HTRecordExerciseModel.h"
#import "HTQuestionManager.h"
#import "HTManagerController+HTRotate.h"

@interface HTWrongRecordController () <HTRotateEveryOne, HTRotateVisible>

@end

@implementation HTWrongRecordController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}


- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	self.navigationItem.title = @"错题记录";
	NSArray *titleArray = @[@"SC", @"CR", @"RC", @"PS", @"DS"];
	NSMutableArray *pageModelArray = [@[] mutableCopy];
	[titleArray enumerateObjectsUsingBlock:^(NSString *title, NSUInteger index, BOOL * _Nonnull stop) {
		HTPageModel *pageModel = [[HTPageModel alloc] init];
		pageModel.selectedTitle = title;
		pageModel.reuseControllerClass = [HTWrongRecordReuseController class];
		[pageModelArray addObject:pageModel];
	}];
	self.pageModelArray = pageModelArray;
	[self setModelArrayBlock:^(NSString *pageIndex, NSString *pageCount, NSString *currentPage, void (^modelArrayStatus)(NSArray<HTRecordExerciseModel *> *, HTError *)) {
		NSArray *modelArray = [HTQuestionManager packExerciseModelWithSectionId:@[@"6", @"8", @"7", @"4", @"5"][pageIndex.integerValue] currentPage:currentPage pageCount:pageCount onlyNeedWrong:true];
		modelArrayStatus(modelArray, nil);
	}];
	[self.magicView reloadData];
}
@end
