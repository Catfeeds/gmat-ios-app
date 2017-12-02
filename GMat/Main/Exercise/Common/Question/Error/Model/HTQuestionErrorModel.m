//
//  HTQuestionErrorModel.m
//  GMat
//
//  Created by hublot on 2017/8/23.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTQuestionErrorModel.h"

@implementation HTQuestionErrorModel

+ (NSArray *)packModelArray {
	NSString *titleNameKey = @"titleNameKey";
	NSString *isSelectedKey = @"isSelectedKey";
	NSArray *keyValueArray = @[
							     @{titleNameKey:@"答案错误", isSelectedKey:@(true)},
								 @{titleNameKey:@"格式有错误", isSelectedKey:@(false)},
								 @{titleNameKey:@"题目内容有错误", isSelectedKey:@(false)},
								 @{titleNameKey:@"其他", isSelectedKey:@(false)},
						     ];
	NSMutableArray *modelArray = [@[] mutableCopy];
	[keyValueArray enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
		HTQuestionErrorModel *model = [[HTQuestionErrorModel alloc] init];
		model.titleName = dictionary[titleNameKey];
		model.isSelected = [dictionary[isSelectedKey] boolValue];
		[modelArray addObject:model];
	}];
	return modelArray;
}

@end
