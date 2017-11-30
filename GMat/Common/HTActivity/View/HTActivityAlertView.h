//
//  HTActivityAlertView.h
//  GMat
//
//  Created by hublot on 2017/8/24.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTActivityAlertView : UIView

+ (void)showActivityWithAnimated:(BOOL)animated image:(UIImage *)image url:(NSString *)url superView:(UIView *)superView;

@end
