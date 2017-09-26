//
//  HTPageController.h
//  GMat
//
//  Created by hublot on 2016/11/1.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "VTMagicController.h"
#import "HTPageModel.h"

@interface HTPageController : VTMagicController

@property (nonatomic, strong) NSMutableArray <HTPageModel *> *pageModelArray;

@property (nonatomic, strong) void(^modelArrayBlock)(NSString *pageIndex, NSString *pageCount, NSString *currentPage, void(^)(NSArray *modelArray, HTError *errorModel));

@end
