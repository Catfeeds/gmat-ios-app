//
//  HTContactUsModel.m
//  GMat
//
//  Created by hublot on 2016/10/25.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTContactUsModel.h"

@implementation HTContactUsModel

- (void)dealloc {
	
}

+ (NSArray <HTContactUsModel *> *)packModelArray {
	NSMutableArray *modelArray = [@[] mutableCopy];
	NSArray *titleNameArray = @[@"雷哥 GMAT 与商科留学", @"雷哥 GMAT 在线", @"service@gmatonline.cn", @"400-1816-180"];
	NSArray *headerTitleArray = @[@"官方微信", @"新浪微博", @"客服邮箱", @"客服电话"];
	[titleNameArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		HTContactUsModel *model = [[HTContactUsModel alloc] init];
		model.titleName = obj;
		model.headerTitle = headerTitleArray[idx];
		[modelArray addObject:model];
	}];
	return modelArray;
}

@end
