//
//  HTExerciseCollectionModel.m
//  GMat
//
//  Created by hublot on 2016/10/18.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTExerciseCollectionModel.h"
#import "HTSingleExerciseController.h"
#import "HTPointExerciseController.h"
#import "HTHardlyExerciseController.h"
#import "HTMockExerciseController.h"
#import "HTSortExerciseController.h"
#import "HTReportExerciseController.h"

@implementation HTExerciseCollectionModel

+ (NSArray <HTExerciseCollectionModel *> *)packModelArray {
	NSString *titleNameKey = @"titleName";
	NSString *imageNameKey = @"imageName";
	NSString *controllerClassStringKey = @"controllerClassString";
	NSString *modelTypeKey = @"modelTypekey";
	NSArray *response = @[
						  @{titleNameKey:@"知识点练习", imageNameKey:@"Exercise6", controllerClassStringKey:NSStringFromClass([HTPointExerciseController class]), modelTypeKey:@(HTExerciseCollectionModelTypePoint)},
						  @{titleNameKey:@"单项练习", imageNameKey:@"Exercise5", controllerClassStringKey:NSStringFromClass([HTSingleExerciseController class]), modelTypeKey:@(HTExerciseCollectionModelTypeSingle)},
						  @{titleNameKey:@"难度做题", imageNameKey:@"Exercise7", controllerClassStringKey:NSStringFromClass([HTHardlyExerciseController class]), modelTypeKey:@(HTExerciseCollectionModelTypeHardly)},
						  @{titleNameKey:@"按照书本练习", imageNameKey:@"Exercise9", controllerClassStringKey:NSStringFromClass([HTSortExerciseController class]), modelTypeKey:@(HTExerciseCollectionModelTypeSort)},
						  @{titleNameKey:@"仿真模考", imageNameKey:@"Exercise8", controllerClassStringKey:NSStringFromClass([HTMockExerciseController class]), modelTypeKey:@(HTExerciseCollectionModelTypeMock)},
						  @{titleNameKey:@"GMAT报告", imageNameKey:@"Exercise10", controllerClassStringKey:NSStringFromClass([HTReportExerciseController class]), modelTypeKey:@(HTExerciseCollectionModelTypeReport)},
						  ];
	NSMutableArray *modelArray = [@[] mutableCopy];
	[response enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
		HTExerciseCollectionModel *model = [[HTExerciseCollectionModel alloc] init];
		model.titleName = dictionary[titleNameKey];
		model.imageName = dictionary[imageNameKey];
		model.controllerClass = NSClassFromString(dictionary[controllerClassStringKey]);
		model.modelType = [dictionary[modelTypeKey] integerValue];
		[modelArray addObject:model];
	}];
	return modelArray;
}

@end
