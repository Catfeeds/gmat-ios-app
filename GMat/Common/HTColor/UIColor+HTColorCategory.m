//
//  UIColor+HTColorCategory.m
//  GMat
//
//  Created by hublot on 17/5/22.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "UIColor+HTColorCategory.h"

@implementation UIColor (HTColorCategory)

+ (instancetype)ht_colorStyle:(HTColorStyle)style {
    NSString *colorString;
    switch (style) {
        case HTColorStyleBackground: {
            colorString = @"ffffff";
            break;
        }
        case HTColorStyleCompareBackground: {
            colorString = @"eeeeee";
            break;
        }
        case HTColorStyleNormalTheme: {
            colorString = @"ff9833";
            break;
        }
        case HTColorStylePrimaryTheme: {
            colorString = @"197fed";
            break;
        }
        case HTColorStyleSecondaryTheme: {
            colorString = @"161718";
            break;
        }
        case HTColorStyleSpecialTheme: {
            colorString = @"33cc66";
            break;
        }
        case HTColorStylePrimarySeparate: {
            colorString = @"e5e5e5";
            break;
        }
        case HTColorStyleSecondarySeparate: {
            colorString = @"cccccc";
            break;
        }
        case HTColorStylePrimaryTitle: {
            colorString = @"333333";
            break;
        }
        case HTColorStyleSecondaryTitle: {
            colorString = @"666666";
            break;
        }
        case HTColorStyleSpecialTitle: {
            colorString = @"999999";
            break;
        }
        case HTColorStyleAnswerRight: {
            colorString = @"3cbe28";
            break;
        }
        case HTColorStyleAnswerWrong: {
            colorString = @"ec3430";
            break;
        }
    }
    UIColor *color = [self ht_colorString:colorString];
    return color;
}

@end
