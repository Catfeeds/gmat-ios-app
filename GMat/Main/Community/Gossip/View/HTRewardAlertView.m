//
//  HTRewardAlertView.m
//  GMat
//
//  Created by Charles Cao on 2017/11/13.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTRewardAlertView.h"
#import "IQKeyboardManager.h"


@implementation HTRewardAlertView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)awakeFromNib
{
	[super awakeFromNib];
	self.inputTextField.layer.borderColor = [UIColor ht_colorString:@"dfdfdf"].CGColor;
}

- (void)setIntegral:(NSInteger)integral{
    _integral = integral;
    self.currentIntegralLabel.text = [NSString stringWithFormat:@"您的雷豆数%ld个",integral];
}

/*
 打赏数量
 tag:100 - 10
 	 101 - 50
 	 102 - 100
 	 103 - 200
 	 104 - 500
 */
- (IBAction)chooseIntegralAction:(UIButton *)sender {
	if (sender != self.selectedBtn) {
		sender.selected = YES;
		self.selectedBtn.selected = NO;
		self.selectedBtn = sender;
		self.inputTextField.text = @"";
		[self.inputTextField resignFirstResponder];
		self.inputTextField.layer.borderColor = [UIColor ht_colorString:@"dfdfdf"].CGColor;
		}
	
}

//打赏
- (IBAction)rewardAction:(UIButton *)sender {
	CGFloat number = 0;
	if (self.selectedBtn){
		switch (self.selectedBtn.tag) {
			case 100:
				number = 10;
				break;
			case 101:
				number = 50;
				break;
			case 102:
				number = 100;
				break;
			case 103:
				number = 200;
				break;
			case 104:
				number = 500;
				break;
			
		}
	}else if (self.inputTextField.text){
		NSString *regex = @"[0-9]*";
		NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
		if ([pred evaluateWithObject:self.inputTextField.text] && [self.inputTextField.text integerValue] > 0) {
			number = [self.inputTextField.text integerValue];
        }else{
            [HTAlert title:@"请输入正确数量"];
            return;
        }
	}
    
    if (number > self.integral) {
        [HTAlert title:@"您的雷豆数不足"];
        return;
    }
    
	if (self.rewardBlock) {
        [self removeFromSuperview];
		self.rewardBlock(number);
	}
}



- (IBAction)cancelAction:(id)sender {
    [self.inputTextField resignFirstResponder];
	[self removeFromSuperview];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
	self.selectedBtn.selected = NO;
	self.selectedBtn = nil;
	textField.layer.borderColor = [UIColor ht_colorString:@"5db7e8"].CGColor;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
	[self.window setNeedsLayout];
	[self.window layoutIfNeeded];
    [IQKeyboardManager sharedManager].enable = NO;
}

@end

@implementation HTRewardSuccessView

- (IBAction)suceAction:(id)sender {
	[self removeFromSuperview];
}
@end
