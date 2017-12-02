//
//  HTLeftModel.m
//  GMat
//
//  Created by hublot on 2016/10/21.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTLeftModel.h"
#import "THMinePreferenceController.h"
#import "HTAboutUsController.h"
#import "HTContactUsController.h"
#import "HTCopyRightController.h"

@implementation HTLeftModel

+ (NSArray <HTLeftModel *> *)packModelArray {
	NSMutableArray *modelArray = [@[] mutableCopy];
	NSArray *titleNameArray = @[@"个人设置", @"关于我们", @"联系我们", @"版权说明"];
	NSArray *controllerClassStringArray = @[NSStringFromClass([THMinePreferenceController class]), NSStringFromClass([HTAboutUsController class]), NSStringFromClass([HTContactUsController class]), NSStringFromClass([HTCopyRightController class])];
	[titleNameArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		HTLeftModel *model = [[HTLeftModel alloc] init];
		model.titleName = obj;
		model.controllerClass = NSClassFromString(controllerClassStringArray[idx]);
		[modelArray addObject:model];
	}];
	return modelArray;
}

@end
