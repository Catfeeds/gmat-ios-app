//
//  HTTryListenModel.m
//  GMat
//
//  Created by hublot on 16/10/13.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTTryListenModel.h"
#import "HTRandomNumberManager.h"

@implementation HTTryListenModel

- (void)mj_keyValuesDidFinishConvertingToObject {
	self.catname = self.contenttitle;
	self.times = self.hour;
	self.teacher = self.teacherName;
	self.playTimes = self.views.integerValue;
	self.webHtmlUrlString = self.contentlink;
}

- (void)appendDataWithIndex:(NSInteger)index {
	NSString *tintColorKey = @"tintColorKey";
	NSString *backgroundImageKey = @"backgroundImageKey";
	NSString *backgroundImageForButtonKey = @"backgroundImageForButtonKey";
	NSArray *keyValueArray = @[
								   @{backgroundImageKey:@"cn_trylisten_1", backgroundImageForButtonKey:@"CourseOld1", tintColorKey:@"a3d540"},
								   @{backgroundImageKey:@"cn_trylisten_2", backgroundImageForButtonKey:@"CourseOld2", tintColorKey:@"ff92b7"},
								   @{backgroundImageKey:@"cn_trylisten_3", backgroundImageForButtonKey:@"CourseOld3", tintColorKey:@"ffb76f"},
								   @{backgroundImageKey:@"cn_trylisten_4", backgroundImageForButtonKey:@"CourseOld4", tintColorKey:@"7f91ff"},
							   ];
	[keyValueArray enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger i, BOOL * _Nonnull stop) {
		if (index == i) {
			self.backgroundImage = dictionary[backgroundImageKey];
			self.backgroundImageForButton = dictionary[backgroundImageForButtonKey];
			self.tintColor = dictionary[tintColorKey];
			*stop = true;
		}
	}];
}

@end
