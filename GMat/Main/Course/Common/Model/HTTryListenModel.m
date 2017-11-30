//
//  HTTryListenModel.m
//  GMat
//
//  Created by hublot on 16/10/13.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTTryListenModel.h"
#import "HTRandomNumberManager.h"
#import <NSString+HTString.h>
#import <NSAttributedString+HTAttributedString.h>
#import <NSMutableAttributedString+HTMutableAttributedString.h>

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

			NSMutableParagraphStyle *warnParagraph = [[NSMutableParagraphStyle alloc] init];
			warnParagraph.lineSpacing = 8;//行间距
			[attributedString addAttribute:NSParagraphStyleAttributeName value:warnParagraph range:range];
		}];
		
		[attributedString ht_changeColorWithColorAlpha:0.7];
		_courseTeacherDetail = attributedString;
	}
	return _courseTeacherDetail;
}

@end
