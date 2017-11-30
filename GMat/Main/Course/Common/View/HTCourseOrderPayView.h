//
//  HTCourseOrderPayView.h
//  GMat
//
//  Created by hublot on 2016/11/17.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTCourseOrderModel.h"

@interface HTCourseOrderPayView : UIView

@property (nonatomic, strong) UILabel *sumPriceLabel;

@property (nonatomic, strong) UIButton *alipayButton;

- (void)setModel:(HTCourseOrderModel *)model;

@end
