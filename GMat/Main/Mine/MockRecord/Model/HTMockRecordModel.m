//
//  HTMockRecordModel.m
//  GMat
//
//  Created by hublot on 2016/11/4.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTMockRecordModel.h"

@implementation HTMockRecordModel

+ (void)load {
	[self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
		return @{@"Id":@"id"};
	}];
}

+ (NSDictionary *)objectClassInArray{
    return @{@"questionanswer" : [MockRecordQuestionanswer class]};
}
@end
@implementation MockRecordReleattr

@end


@implementation MockRecordPace

@end


@implementation MockRecordCorrect

@end


@implementation MockRecordS

@end


@implementation MockRecordSc

@end


@implementation MockRecordRc

@end


@implementation MockRecordCr

@end


@implementation MockRecordPs

@end


@implementation MockRecordDs

@end


@implementation MockRecordCredit

@end


@implementation MockRecordQuestionanswer

@end


