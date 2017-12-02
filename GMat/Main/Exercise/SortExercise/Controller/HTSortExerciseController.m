//
//  HTSortExerciseController.m
//  GMat
//
//  Created by hublot on 2017/8/3.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTSortExerciseController.h"
#import "HTSingleExerciseContentController.h"
#import "HTExerciseModel.h"
#import "HTQuestionManager.h"
#import "HTManagerController+HTRotate.h"

@interface HTSortExerciseController () <HTRotateVisible, HTRotateEveryOne>

@end

@implementation HTSortExerciseController

- (void)viewDidLoad {
	self.firstRowTitleArray = @[@"OG2017", @"PREP08", @"OG18新题"];
	self.secondRowTitleArray = @[@"SC", @"CR", @"RC"];
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	self.navigationItem.title = @"按照书本练习";
	self.reuseControllerClass = [HTSingleExerciseContentController class];
	NSArray *twoObjectArray = @[@[@"1"],
								@[@"10"],
								@[@"18"]];
	
	NSArray *sectionidArray = @[@"6",
								@"8",
								@"7"];
	[self setModelArrayBlock:^(NSString *firstSelectedIndex, NSString *secondSelectedIndex, NSString *pageCount, NSString *currentPage, void (^modelArrayStatus)(NSArray <HTExerciseModel *> *, HTError *errorModel)) {
		if (currentPage.integerValue > 1) {
			modelArrayStatus(@[], nil);
			return;
		}
		NSArray *towObject = twoObjectArray[firstSelectedIndex.integerValue];
		NSString *sectionId = sectionidArray[secondSelectedIndex.integerValue];
		NSMutableArray <HTExerciseModel *> *modelArray = [HTQuestionManager packSortExerciseModelArrayWithSectionId:sectionId twoObjectIdArray:towObject];
		[modelArray enumerateObjectsUsingBlock:^(HTExerciseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			obj.modelStyle = HTExerciseModelStyleSort;
		}];
		modelArrayStatus(modelArray, nil);
	}];
}

@end
