//
//  THTeacherDetailAlertView.m
//  TingApp
//
//  Created by hublot on 16/8/31.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "THTeacherDetailAlertView.h"
#import "THTeacherDetailAlertTextField.h"
#import <HTValidateManager.h>


@interface THTeacherDetailAlertView ()

@property (nonatomic, strong) UIView *placeBackView;

@property (nonatomic, strong) THTeacherDetailAlertTextField *nameTextField;

@property (nonatomic, strong) THTeacherDetailAlertTextField *phoneTextField;

@property (nonatomic, strong) UILabel *helpLabel;

@property (nonatomic, strong) UIButton *sureButton;

@property (nonatomic, strong) UIButton *rightHideButton;

@property (nonatomic, copy) void(^sureAction)(NSString *firstTextFieldString, NSString *secondTextFieldString);

@end

@implementation THTeacherDetailAlertView

static THTeacherDetailAlertView *teacherAlertView;

+ (instancetype)defaultTeacherAlertView {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		teacherAlertView = [[THTeacherDetailAlertView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - HTADAPT568(60), 285)];
	});
	return teacherAlertView;
}

+ (void)showTeacherAlert:(void(^)(NSString *firstTextFieldString, NSString *secondTextFieldString))teacherAlert {
	[THTeacherDetailAlertView defaultTeacherAlertView].sureAction = teacherAlert;
	[[THTeacherDetailAlertView defaultTeacherAlertView].nameTextField removeFromSuperview];
	[THTeacherDetailAlertView defaultTeacherAlertView].nameTextField = nil;
	[[THTeacherDetailAlertView defaultTeacherAlertView].phoneTextField removeFromSuperview];
	[THTeacherDetailAlertView defaultTeacherAlertView].phoneTextField = nil;
	[[UIApplication sharedApplication].keyWindow addSubview:[THTeacherDetailAlertView defaultTeacherAlertView].placeBackView];
	[[THTeacherDetailAlertView defaultTeacherAlertView].placeBackView addSubview:[THTeacherDetailAlertView defaultTeacherAlertView]];
	[THTeacherDetailAlertView defaultTeacherAlertView].center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, -[THTeacherDetailAlertView defaultTeacherAlertView].bounds.size.height);
	[UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.85 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		[THTeacherDetailAlertView defaultTeacherAlertView].center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2 - 50);
		[THTeacherDetailAlertView defaultTeacherAlertView].alpha = 1;
	} completion:^(BOOL finished) {
		
	}];
}

- (void)hideTeacherAlert {
	[[THTeacherDetailAlertView defaultTeacherAlertView].placeBackView removeFromSuperview];
	[UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		[THTeacherDetailAlertView defaultTeacherAlertView].alpha = 0;
	} completion:^(BOOL finished) {
		[[THTeacherDetailAlertView defaultTeacherAlertView] removeFromSuperview];
	}];
}

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor whiteColor];
	self.layer.cornerRadius = 10;
	[self addSubview:self.rightHideButton];
	[self addSubview:self.nameTextField];
	[self addSubview:self.phoneTextField];
	[self addSubview:self.helpLabel];
	[self addSubview:self.sureButton];
	[self ht_whenTap:^(UIView *view) {
		[self.nameTextField hideKeyBoard];
		[self.phoneTextField hideKeyBoard];
	}];
	UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
	pointView.layer.cornerRadius = 6;
	pointView.layer.masksToBounds = true;
	pointView.backgroundColor = [UIColor ht_colorString:@"646464"];
	pointView.center = CGPointMake(self.ht_w / 2, 12);
	[self addSubview:pointView];
	
	UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.ht_w / 2, 13 - [UIScreen mainScreen].bounds.size.height, 1, [UIScreen mainScreen].bounds.size.height)];
	lineView.backgroundColor = [UIColor whiteColor];
	[self addSubview:lineView];
}

- (UIView *)placeBackView {
	if (!_placeBackView) {
		_placeBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
		_placeBackView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
		[_placeBackView ht_whenTap:^(UIView *view) {
			[self.nameTextField hideKeyBoard];
			[self.phoneTextField hideKeyBoard];
		}];
	}
	return _placeBackView;
}

- (UIButton *)rightHideButton {
	if (!_rightHideButton) {
		_rightHideButton = [[UIButton alloc] initWithFrame:CGRectMake(self.ht_w - 40, 0, 40, 40)];
		[_rightHideButton setImage:[UIImage imageNamed:@"Course37"] forState:UIControlStateNormal];
		[_rightHideButton ht_whenTap:^(UIView *view) {
			[[THTeacherDetailAlertView defaultTeacherAlertView] hideTeacherAlert];
		}];
	}
	return _rightHideButton;
}

- (THTeacherDetailAlertTextField *)nameTextField {
	if (!_nameTextField) {
		_nameTextField = [[THTeacherDetailAlertTextField alloc] initWithFrame:CGRectMake(15, 30, self.ht_w - 30, 60) helpLabelText:@"请输入您的姓名"];
	}
	return _nameTextField;
}

- (THTeacherDetailAlertTextField *)phoneTextField {
	if (!_phoneTextField) {
		_phoneTextField = [[THTeacherDetailAlertTextField alloc] initWithFrame:CGRectMake(15, 100, self.ht_w - 30, 60) helpLabelText:@"请输入您的电话"];
	}
	return _phoneTextField;
}

- (UILabel *)helpLabel {
	if (!_helpLabel) {
		_helpLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 180, self.ht_w - 30, 20)];
		_helpLabel.text = @"我们将会在一个工作日内与您取得联系哦~";
		_helpLabel.textAlignment = NSTextAlignmentCenter;
		_helpLabel.textColor = [UIColor ht_colorString:@"ee0000"];
		_helpLabel.font = [UIFont ht_fontStyle:HTFontStyleDetailLarge];
	}
	return _helpLabel;
}

- (UIButton *)sureButton {
	if (!_sureButton) {
		_sureButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 220, self.ht_w - 30, 40)];
		_sureButton.backgroundColor = [UIColor ht_colorStyle:HTColorStyleSpecialTheme];
		[_sureButton setTitle:@"确认提交" forState:UIControlStateNormal];
		_sureButton.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleTitleLarge];
		[_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		_sureButton.layer.cornerRadius = 8;
		_sureButton.layer.masksToBounds = true;
		[_sureButton ht_whenTap:^(UIView *view) {
			if ([self.nameTextField.text isEqualToString:@""]) {
				[HTAlert title:@"输入一个名字吧"];
			} else if (![HTValidateManager ht_validateMobile:self.phoneTextField.text]) {
				[HTAlert title:@"手机号码格式不大对哦"];
			} else {
				if (self.sureAction) {
					self.sureAction(self.nameTextField.text, self.phoneTextField.text);
					[self hideTeacherAlert];
				}
			}
		}];
	}
	return _sureButton;
}


@end
