//
//  HTExerciseQuestionCountModel.m
//  GMat
//
//  Created by hublot on 2017/6/1.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTExerciseQuestionCountModel.h"
#import <HTRandomNumberManager.h>

@implementation HTExerciseQuestionCountModel

- (NSString *)verbalNum {
	NSInteger verbalNumber = _verbalNum.integerValue;
	verbalNumber = MAX(3638, verbalNumber);
	NSString *verbalNum = [NSString stringWithFormat:@"%ld", verbalNumber];
	return verbalNum;
}

- (NSString *)quantNum {
	NSInteger quantNumber = _quantNum.integerValue;
	quantNumber = MAX(2957, quantNumber);
	NSString *quantNum = [NSString stringWithFormat:@"%ld", quantNumber];
	return quantNum;
}

- (NSString *)viewCount {
	NSString *viewCountIdentifier = @"HTExerciseQuestionCountModelViewCount";
	[HTRandomNumberManager ht_saveLastUpdateIdentifier:viewCountIdentifier lastSaveTime:1497888000 lastSaveCountString:@"39351" onlyInitFirst:true];
	NSInteger randViewCount = [HTRandomNumberManager ht_randomIntegerWithIdentifier:viewCountIdentifier minBeginCount:0 maxBeginCount:0 minAppendCount:128 maxAppendCount:128 spendHour:24];
	NSString *viewCount = [NSString stringWithFormat:@"%ld", randViewCount];
	return viewCount;
}

@end
