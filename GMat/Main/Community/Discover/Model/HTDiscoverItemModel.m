//
//  HTDiscoverItemModel.m
//  GMat
//
//  Created by hublot on 2017/7/4.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTDiscoverItemModel.h"

@implementation HTDiscoverItemModel

+ (NSArray  <HTDiscoverItemModel *> *)packModelArray {
	NSMutableArray *modelArray = [@[] mutableCopy];
	NSString *itemTypeKey = @"itemTypeKey";
	NSString *itemIdKey = @"itemIdKey";
	NSString *itemTitleKey = @"itemTitleKey";
	NSString *itemImageKey = @"itemImageKey";
	NSArray *keyValueArray = @[
							   @{itemTypeKey:@(HTDiscoverItemTypeTime), itemIdKey:@"32", itemTitleKey:@"考试时间", itemImageKey:@"CommunityDiscoverDate"},
							   @{itemTypeKey:@(HTDiscoverItemTypeAddress), itemIdKey:@"41", itemTitleKey:@"考试地点", itemImageKey:@"CommunityDiscoverAddress"},
							   @{itemTypeKey:@(HTDiscoverItemTypeContent), itemIdKey:@"42", itemTitleKey:@"考试内容", itemImageKey:@"CommunityDiscoverContent"},
							   @{itemTypeKey:@(HTDiscoverItemTypeStep), itemIdKey:@"43", itemTitleKey:@"报名流程", itemImageKey:@"CommunityDiscoverStep"},
							   @{itemTypeKey:@(HTDiscoverItemTypeMoney), itemIdKey:@"44", itemTitleKey:@"考试费用", itemImageKey:@"CommunityDiscoverMoney"},
							   @{itemTypeKey:@(HTDiscoverItemTypeIssue), itemIdKey:@"45", itemTitleKey:@"成绩复议", itemImageKey:@"CommunityDiscoverIssue"},
							   @{itemTypeKey:@(HTDiscoverItemTypeCard), itemIdKey:@"46", itemTitleKey:@"考试证件", itemImageKey:@"CommunityDiscoverCard"},
							   @{itemTypeKey:@(HTDiscoverItemTypeExit), itemIdKey:@"47", itemTitleKey:@"转考退考", itemImageKey:@"CommunityDiscoverExit"},
							   @{itemTypeKey:@(HTDiscoverItemTypeScore), itemIdKey:@"48", itemTitleKey:@"送分方式", itemImageKey:@"CommunityDiscoverScore"},
							   ];
	[keyValueArray enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger index, BOOL * _Nonnull stop) {
		HTDiscoverItemModel *model = [[HTDiscoverItemModel alloc] init];
		model.type = [dictionary[itemTypeKey] integerValue];
		model.itemId = dictionary[itemIdKey];
		model.titleName = dictionary[itemTitleKey];
		model.imageName = dictionary[itemImageKey];
		[modelArray addObject:model];
	}];
	return modelArray;
}

@end
