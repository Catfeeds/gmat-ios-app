//
//  HTCourseHotModel.m
//  GMat
//
//  Created by hublot on 2017/4/19.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTCourseHotModel.h"
#import "HTRandomNumberManager.h"

@implementation CourseResult

@end

@implementation HTCourseHotModel

- (void)resetJoinTimesWithIndex:(NSInteger)index {
	NSArray *startCountArray = @[@"203", @"335", @"289"];
	NSString *startCountString = startCountArray.firstObject;
	if (startCountArray.count > index) {
		startCountString = startCountArray[index];
	}
	NSString *identifier = [NSString stringWithFormat:@"%@%@", NSStringFromClass(self.class), self.result.contentid];
	[HTRandomNumberManager ht_saveLastUpdateIdentifier:identifier lastSaveTime:1497888000 lastSaveCountString:startCountString onlyInitFirst:true];
	NSInteger randomNumber = [HTRandomNumberManager ht_randomIntegerWithIdentifier:identifier minBeginCount:0 maxBeginCount:0 minAppendCount:27 maxAppendCount:27 spendHour:24];
	self.joinTimes = randomNumber;
}

@end
