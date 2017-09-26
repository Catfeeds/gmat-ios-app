//
//  HTOctopusAlertView.h
//  GMat
//
//  Created by hublot on 16/11/29.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTOctopusAlertView : UIView

+ (HTOctopusAlertView *)title:(NSString *)title message:(NSString *)message tryAgainTitle:(NSString *)tryAgainTitle tryAgainBlock:(void(^)(void))tryAgainBlock;

+ (void)dissmissAlert;

@end
