
//
//  HTExerciseModel.m
//  GMat
//
//  Created by hublot on 2016/10/31.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTExerciseModel.h"

@implementation HTExerciseModel

- (void)dealloc {
	
}

- (void)setValue:(id)value forKey:(NSString *)key {
	if ([key isEqualToString:@"totalnum"]) {
		self.lowertknumb = [value integerValue];
	} else if ([key isEqualToString:@"ukqnubm"]) {
		self.userlowertk = value;
	} else if ([key isEqualToString:@"Total"]) {
		self.lowertknumb = [value integerValue];
	} else {
		[super setValue:value forKey:key];
	}
}

+ (void)load {
	[self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
		return @{@"Id":@"id"};
	}];
}

@end
