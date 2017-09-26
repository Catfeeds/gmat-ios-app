//
//  HTQuestionMoreMenuModel.m
//  GMat
//
//  Created by hublot on 2017/8/23.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTQuestionMoreMenuModel.h"

@implementation HTQuestionMoreMenuModel

+ (NSArray <HTQuestionMoreMenuModel *> *)packModelArray {
	NSString *itemTypeKey = @"itemTypeKey";
	NSString *isHiddenKey = @"isHiddenKey";
	NSString *titleNameKey = @"titleNameKey";
	NSString *isSelectedKey = @"isSelectedKey";
	NSString *selectedTitleKey = @"selectedTitleKey";
	NSArray *keyValueArray = @[
							     @{itemTypeKey:@(HTQuestionMoreItemTypeParse), isHiddenKey:@(false), titleNameKey:@"查看解析", isSelectedKey:@(false), selectedTitleKey:@"关闭解析"},
								 @{itemTypeKey:@(HTQuestionMoreItemTypeFont), isHiddenKey:@(false), titleNameKey:@"字体设置", isSelectedKey:@(false), selectedTitleKey:@"字体设置"},
								 @{itemTypeKey:@(HTQuestionMoreItemTypeError), isHiddenKey:@(false), titleNameKey:@"题目纠错", isSelectedKey:@(false), selectedTitleKey:@"题目纠错"},
							 ];
	NSMutableArray *modelArray = [@[] mutableCopy];
	[keyValueArray enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
		HTQuestionMoreMenuModel *model = [[HTQuestionMoreMenuModel alloc] init];
		model.type = [dictionary[itemTypeKey] integerValue];
		model.isHidden = [dictionary[isHiddenKey] boolValue];
		model.titleName = dictionary[titleNameKey];
		model.isSelected = [dictionary[isSelectedKey] boolValue];
		model.selectedTitle = dictionary[selectedTitleKey];
		[modelArray addObject:model];
	}];
	return modelArray;
}

@end
