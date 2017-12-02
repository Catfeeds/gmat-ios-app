//
//  HTMockExerciseModel.m
//  GMat
//
//  Created by hublot on 2016/10/26.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTMockExerciseModel.h"

@implementation HTMockExerciseModel

+ (NSArray <HTMockExerciseModel *> *)packModelArray {
	NSArray *titleNameArray = @[@"语文套题", @"数学套题", @"全套套题"];
	NSArray *detailNameArray = @[@"69套模考全方位满足你的需求", @"59套模考全方位满足你的需求", @"59套模考全方位满足你的需求"];
	NSMutableArray *modelArray = [@[] mutableCopy];
	[titleNameArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		HTMockExerciseModel *exerciseModel = [[HTMockExerciseModel alloc] init];
		exerciseModel.titleName = obj;
		exerciseModel.detailName = detailNameArray[idx];
		[modelArray addObject:exerciseModel];
	}];
	return modelArray;
}

@end
