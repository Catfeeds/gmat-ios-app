//
//  HTRewardAlertView.h
//  GMat
//
//  Created by Charles Cao on 2017/11/13.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface HTRewardAlertView : UIView <UITextFieldDelegate>

@property (nonatomic, assign) NSInteger integral; //雷豆数量
@property (nonatomic, strong) UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UILabel *currentIntegralLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (nonatomic, copy) void (^rewardBlock)(NSInteger num);
@end


@interface HTRewardSuccessView : UIView

@end;
