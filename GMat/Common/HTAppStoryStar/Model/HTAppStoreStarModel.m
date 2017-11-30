//
//  HTAppStoreStarModel.m
//  GMat
//
//  Created by hublot on 2017/8/4.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTAppStoreStarModel.h"

@implementation HTAppStoreStarModel

+ (NSArray <HTAppStoreStarModel *> *)packModelArray {
	NSString *titleNameKey = @"titleNameKey";
	NSString *titleColorKey = @"titleColorKey";
	NSString *modelTypeKey = @"modelTypeKey";
	NSArray *keyValueArray = @[@{modelTypeKey:@(HTAppStoreStarTypeGood), titleNameKey:@"喜欢, 给五星好评", titleColorKey:[UIColor ht_colorString:@"f77911"]},
							   @{modelTypeKey:@(HTAppStoreStarTypeIssue), titleNameKey:@"我要吐槽", titleColorKey:[UIColor ht_colorString:@"f77911"]},
							   @{modelTypeKey:@(HTAppStoreStarTypeReject), titleNameKey:@"残忍拒绝", titleColorKey:[UIColor ht_colorStyle:HTColorStyleSecondaryTitle]}];
	NSMutableArray *modelArray = [@[] mutableCopy];
	[keyValueArray enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger index, BOOL * _Nonnull stop) {
		HTAppStoreStarModel *model = [[HTAppStoreStarModel alloc] init];
		model.type = [dictionary[modelTypeKey] integerValue];
		model.titleName = dictionary[titleNameKey];
		model.titleColor = dictionary[titleColorKey];
		[modelArray addObject:model];
	}];
	return modelArray;
}

@end
