//
//  HTExercisePageController.h
//  GMat
//
//  Created by hublot on 2017/5/8.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "VTMagic.h"

@interface HTExercisePageController : VTMagicController

@property (nonatomic, copy) void(^modelArrayBlock)(NSString *firstPageIndex, NSString *sectondIndex, NSString *pageCount, NSString *currentPage, void(^)(NSArray *modelArray, HTError *errorModel));

@property (nonatomic, assign) Class reuseControllerClass;

@property (nonatomic, strong) NSArray *firstRowTitleArray;

@property (nonatomic, strong) NSArray *secondRowTitleArray;

- (void)reloadMagicView;

@end
