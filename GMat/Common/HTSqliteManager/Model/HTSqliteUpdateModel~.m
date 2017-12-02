//
//  HTSqliteUpdateModel.m
//  GMat
//
//  Created by hublot on 2017/8/11.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTSqliteUpdateModel.h"

@implementation HTSqliteUpdateModel


+ (NSDictionary *)objectClassInArray{
    return @{@"parse" : [HTSqliteParseModel class], @"question" : [HTSqliteQuestionModel class], @"tiku" : [HTSqliteExerciseModel class], @"xuhaoQuestion":[HTSqliteSortQuestionModel class], @"xuhaoTiku":[HTSqliteSortExerciseModel class]};
}
@end
@implementation HTSqliteParseModel

@end


@implementation HTSqliteQuestionModel

@end


@implementation HTSqliteExerciseModel

@end

@implementation HTSqliteSortQuestionModel

+ (void)load {
	[self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
		return @{@"ID":@"id"};
	}];
}

@end

@implementation HTSqliteSortExerciseModel

+ (void)load {
	[self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
		return @{@"ID":@"id"};
	}];
}

@end
