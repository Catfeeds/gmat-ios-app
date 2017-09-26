//
//  HTCourseOpenModel.m
//  GMat
//
//  Created by hublot on 2016/12/14.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTCourseOpenModel.h"
#import "HTRandomNumberManager.h"

@implementation HTCourseOpenModel

- (void)resetJoinTimes {
	NSString *identifier = [NSString stringWithFormat:@"%@%@", NSStringFromClass(self.class), self.id];
	NSInteger randomNumber = [HTRandomNumberManager ht_randomIntegerWithIdentifier:identifier minBeginCount:30 maxBeginCount:200 minAppendCount:7 maxAppendCount:11 spendHour:24];
	self.joinTimes = randomNumber;
}

@end
