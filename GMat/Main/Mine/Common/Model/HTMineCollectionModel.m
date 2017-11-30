//
//  HTMineCollectionModel.m
//  GMat
//
//  Created by hublot on 2016/10/19.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTMineCollectionModel.h"
#import "HTWrongRecordController.h"
#import "HTExerciseRecordController.h"
#import "HTMockRecordController.h"
#import "HTDownloadProgressController.h"
#import "HTStoreController.h"
#import "HTMessageController.h"

@implementation HTMineCollectionModel

+ (NSArray <HTMineCollectionModel *> *)packModelArray {
	NSMutableArray *modelArray = [@[] mutableCopy];
	NSArray *titleNameArray = @[@"错题记录", @"做题记录", @"模考记录", @"文件记录", @"收藏记录", @"消息记录"];
	NSArray *imageNameArray = @[@"Mine2", @"Mine3", @"Mine4", @"Mine5", @"Mine6", @"Mine7"];
	NSArray *controllerClassStringArray = @[NSStringFromClass([HTWrongRecordController class]), NSStringFromClass([HTExerciseRecordController class]), NSStringFromClass([HTMockRecordController class]), NSStringFromClass([HTDownloadProgressController class]), NSStringFromClass([HTStoreController class]), NSStringFromClass([HTMessageController class])];
	[titleNameArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		HTMineCollectionModel *model = [[HTMineCollectionModel alloc] init];
		model.titleName = obj;
		model.imageName = imageNameArray[idx];
		model.controllerClass = NSClassFromString(controllerClassStringArray[idx]);
		[modelArray addObject:model];
	}];
	return modelArray;
}

@end
