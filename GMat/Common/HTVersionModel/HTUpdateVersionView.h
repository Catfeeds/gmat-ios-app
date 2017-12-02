//
//  HTUpdateVersionView.h
//  GMat
//
//  Created by hublot on 2017/7/18.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTUpdateVersionView : UIView

+ (void)showWithSureBlock:(void(^)(void))sureBlock attributedString:(NSAttributedString *)attributedString animate:(BOOL)animated superView:(UIView *)superView;

@end
