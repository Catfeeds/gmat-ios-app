//
//  UIFont+HTFont.h
//  TingApp
//
//  Created by hublot on 2017/5/27.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HTFontStyle) {
	HTFontStyleHeadLarge,
	HTFontStyleHeadSmall,
	HTFontStyleTitleLarge,
	HTFontStyleTitleSmall,
	HTFontStyleDetailLarge,
	HTFontStyleDetailSmall
};

@interface UIFont (HTFont)

+ (instancetype)ht_fontStyle:(HTFontStyle)style;

+ (instancetype)ht_adaptFontOnlyCodeButFontWithInterBuilderWithHeight568FontSize:(CGFloat)size;

- (instancetype)ht_userSizeFont;

@end
