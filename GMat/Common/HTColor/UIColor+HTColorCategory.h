//
//  UIColor+HTColorCategory.h
//  GMat
//
//  Created by hublot on 17/5/22.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIColor+HTColor.h>

typedef NS_ENUM(NSInteger, HTColorStyle) {
    HTColorStyleBackground,
    HTColorStyleCompareBackground,
    HTColorStyleNormalTheme,
    HTColorStylePrimaryTheme,
    HTColorStyleSecondaryTheme,
    HTColorStyleSpecialTheme,
    HTColorStylePrimarySeparate,
    HTColorStyleSecondarySeparate,
    HTColorStylePrimaryTitle,
    HTColorStyleSecondaryTitle,
    HTColorStyleSpecialTitle,
    HTColorStyleAnswerRight,
    HTColorStyleAnswerWrong
};

@interface UIColor (HTColorCategory)

+ (instancetype)ht_colorStyle:(HTColorStyle)style;

@end
