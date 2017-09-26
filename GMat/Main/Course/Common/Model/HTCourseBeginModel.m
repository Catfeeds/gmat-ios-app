//
//  HTCourseBeginModel.m
//  GMat
//
//  Created by hublot on 2017/4/19.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTCourseBeginModel.h"
#import "HTRandomNumberManager.h"

@implementation HTCourseBeginModel

- (void)mj_keyValuesDidFinishConvertingToObject {
	self.catname = self.contenttitle;
	self.times = self.hour;
	self.playTimes = self.views.integerValue;
	self.webHtmlUrlString = self.contentlink;
}

- (void)appendDataWithIndex:(NSInteger)index {
	NSString *tintColorKey = @"tintColorKey";
	NSString *backgroundImageKey = @"backgroundImageKey";
	NSArray *keyValueArray = @[
								   @{backgroundImageKey:@"cn_begin_1", tintColorKey:@"89d479"},
								   @{backgroundImageKey:@"cn_begin_2", tintColorKey:@"ffa748"},
								   @{backgroundImageKey:@"cn_begin_3", tintColorKey:@"ffb299"},
								   @{backgroundImageKey:@"cn_begin_4", tintColorKey:@"74d1d0"},
							   ];
	[keyValueArray enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger i, BOOL * _Nonnull stop) {
		if (index == i) {
			self.tintColor = dictionary[tintColorKey];
			self.backgroundImage = dictionary[backgroundImageKey];
			*stop = true;
		}
	}];
}

@end
