//
//  HTCourseBeginModel.m
//  GMat
//
//  Created by hublot on 2017/4/19.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTCourseBeginModel.h"
#import "HTRandomNumberManager.h"
#import <NSString+HTString.h>
#import <NSAttributedString+HTAttributedString.h>
#import <NSMutableAttributedString+HTMutableAttributedString.h>

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

- (NSString *)courseURLString {
	return self.webHtmlUrlString;
}

- (NSString *)courseTitleString {
	return self.catname;
}

- (NSString *)courseTeacherImage {
	return HTPlaceholderString(self.teacherPhoto, @"");
}

- (NSAttributedString *)courseTeacherTitle {
	if (!_courseTeacherTitle) {
		NSDictionary *dictionary = @{NSFontAttributeName:[UIFont systemFontOfSize:16],
									 NSForegroundColorAttributeName:[UIColor ht_colorString:@"333333"]};
		_courseTeacherTitle = [[NSAttributedString alloc] initWithString:HTPlaceholderString(self.teacherTitle, @"") attributes:dictionary];
	}
	return _courseTeacherTitle;
}

- (NSAttributedString *)courseTeacherDetail {
	if (!_courseTeacherDetail) {
		NSMutableAttributedString *attributedString = [[[self.teacherData ht_htmlDecodeString] ht_attributedStringNeedDispatcher:nil] mutableCopy];
		[attributedString ht_EnumerateAttribute:NSFontAttributeName usingBlock:^(UIFont *nativeFont, NSRange range, BOOL *stop) {
			UIFont *customFont = [UIFont fontWithDescriptor:nativeFont.fontDescriptor size:MAX(15, nativeFont.pointSize)];
			[attributedString addAttributes:@{NSFontAttributeName:customFont} range:range];
		}];
		[attributedString ht_changeColorWithColorAlpha:0.7];
		_courseTeacherDetail = attributedString;
	}
	return _courseTeacherDetail;
}

@end
