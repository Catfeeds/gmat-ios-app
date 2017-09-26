//
//  HTExerciseSearchModel.m
//  GMat
//
//  Created by hublot on 2017/5/17.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTExerciseSearchModel.h"

@implementation HTExerciseSearchModel

+ (NSArray <HTExerciseSearchModel *> *)packModelArray {
	NSString *titleNameKey = @"titleName";
	NSString *imageNamekey = @"imageName";
	NSString *searchTypeKey = @"searchTypeNumber";
	NSArray *response = @[
  						@{titleNameKey:@"拍照找题", imageNamekey:@"ExerciseTakePhoto", searchTypeKey:@(HTExerciseSearchModelTypeTakePhoto)},
						@{titleNameKey:@"语音找题", imageNamekey:@"ExerciseVoice", searchTypeKey:@(HTExerciseSearchModelTypeVoice)},
						@{titleNameKey:@"搜索找题", imageNamekey:@"ExerciseSearch", searchTypeKey:@(HTExerciseSearchModelTypeSearch)},
						];
	NSMutableArray *modelArray = [@[] mutableCopy];
	[response enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
		HTExerciseSearchModel *model = [[HTExerciseSearchModel alloc] init];
		model.titleName = dictionary[titleNameKey];
		model.imageName = dictionary[imageNamekey];
		model.searchType = [dictionary[searchTypeKey] integerValue];
		[modelArray addObject:model];
	}];
	return modelArray;
}

@end
