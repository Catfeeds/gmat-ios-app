//
//  HTIsPayAlertView.h
//  GMat
//
//  Created by Charles Cao on 2017/11/6.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTIsPayAlertView : UIView

@property (weak, nonatomic) IBOutlet UILabel *currentIntegral; //雷豆数量
@property (nonatomic, copy) void(^confirmAction)();

@property (weak, nonatomic) IBOutlet UILabel *describeLabel;  //雷豆文字描述

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
