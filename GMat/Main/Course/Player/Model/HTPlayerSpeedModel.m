//
//  HTPlayerSpeedModel.m
//  GMat
//
//  Created by hublot on 2017/9/28.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTPlayerSpeedModel.h"

@implementation HTPlayerSpeedModel

- (void)dealloc {
	
}

+ (NSArray *)packModelArray {
	NSString *titleNameKey = @"titleNameKey";
	NSString *rateStringKey = @"rateStringKey";
	NSString *isSelectedKey = @"isSelectedKey";
	NSArray *keyValueArray = @[
							 	 @{titleNameKey:@"1.0 倍", rateStringKey:@(1.0), isSelectedKey:@(true)},
								 @{titleNameKey:@"1.2 倍", rateStringKey:@(1.2), isSelectedKey:@(false)},
								 @{titleNameKey:@"1.5 倍", rateStringKey:@(1.5), isSelectedKey:@(false)},
								 @{titleNameKey:@"2.0 倍", rateStringKey:@(2.0), isSelectedKey:@(false)},
							 ];
	NSMutableArray *modelArray = [@[] mutableCopy];
	[keyValueArray enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger index, BOOL * _Nonnull stop) {
		HTPlayerSpeedModel *model = [[HTPlayerSpeedModel alloc] init];
		model.titleName = dictionary[titleNameKey];
		model.rate = [dictionary[rateStringKey] floatValue];
		model.isSelected = [dictionary[isSelectedKey] boolValue];
		[modelArray addObject:model];
	}];
	return modelArray;
}

@end
