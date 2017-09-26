//
//  HTMockExerciseModel.h
//  GMat
//
//  Created by hublot on 2016/10/26.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTMockExerciseModel : NSObject

@property (nonatomic, strong) NSString *titleName;

@property (nonatomic, strong) NSString *detailName;

+ (NSArray <HTMockExerciseModel *> *)packModelArray;

@end
