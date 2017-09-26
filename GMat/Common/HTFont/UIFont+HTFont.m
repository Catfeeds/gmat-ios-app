//
//  UIFont+HTFont.m
//  TingApp
//
//  Created by hublot on 2017/5/27.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "UIFont+HTFont.h"
#import "HTMineFontSizeController.h"

@implementation UIFont (HTFont)

+ (instancetype)ht_fontStyle:(HTFontStyle)style {
	UIFont *font;
	switch (style) {
		case HTFontStyleHeadLarge: {
			font = [self ht_adaptFontOnlyCodeButFontWithInterBuilderWithHeight568FontSize:18];
			break;
		}
		case HTFontStyleHeadSmall: {
			font = [self ht_adaptFontOnlyCodeButFontWithInterBuilderWithHeight568FontSize:15];
			break;
		}
		case HTFontStyleTitleLarge: {
			font = [self ht_adaptFontOnlyCodeButFontWithInterBuilderWithHeight568FontSize:14];
			break;
		}
		case HTFontStyleTitleSmall: {
			font = [self ht_adaptFontOnlyCodeButFontWithInterBuilderWithHeight568FontSize:13];
			break;
		}
		case HTFontStyleDetailLarge: {
			font = [self ht_adaptFontOnlyCodeButFontWithInterBuilderWithHeight568FontSize:12];
			break;
		}
		case HTFontStyleDetailSmall: {
			font = [self ht_adaptFontOnlyCodeButFontWithInterBuilderWithHeight568FontSize:11];
			break;
		}
	}
	return font;
}

+ (instancetype)ht_adaptFontOnlyCodeButFontWithInterBuilderWithHeight568FontSize:(CGFloat)size {
	return [self systemFontOfSize:HTADAPT568(size)];
}

- (instancetype)ht_userSizeFont {
	CGFloat fontSizeZoomNumber = [HTMineFontSizeController fontZoomNumber];
	CGFloat pointSize = self.pointSize;
	pointSize *= fontSizeZoomNumber;
	UIFont *font = [UIFont fontWithDescriptor:self.fontDescriptor size:pointSize];
	return font;
}

@end
