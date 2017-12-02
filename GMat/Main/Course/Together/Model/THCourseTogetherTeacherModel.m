//
//  THCourseTogethreTeacherModel.m
//  TingApp
//
//  Created by hublot on 16/8/31.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "THCourseTogetherTeacherModel.h"
#import "HTRandomNumberManager.h"

@implementation THCourseTogetherTeacherModel

+ (void)load {
	[self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
		return @{@"Description":@"description"};
	}];
}

- (void)resetJoinTimes {
	NSString *identifier = [NSString stringWithFormat:@"%@%@", NSStringFromClass(self.class), self.teacherId];
	NSInteger randomNumber = [HTRandomNumberManager ht_randomIntegerWithIdentifier:identifier minBeginCount:30 maxBeginCount:200 minAppendCount:3 maxAppendCount:6 spendHour:24];
	self.joinTimes = randomNumber;
}

@end
