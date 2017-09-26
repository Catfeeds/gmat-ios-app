//
//  HTLoginTextFieldGroupView.m
//  GMat
//
//  Created by hublot on 2016/10/27.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTLoginTextFieldGroupView.h"
#import <HTValidateManager.h>


@interface HTLoginTextFieldGroupView ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation HTLoginTextFieldGroupView

- (void)dealloc {
	
}

- (void)resignFirstResponder {
	[@[self.usernameTextField, self.passwordTextField, self.surePasswordTextField, self.phoneEmailTextField, self.messageCodeTextFiled] enumerateObjectsUsingBlock:^(UITextField *obj, NSUInteger idx, BOOL * _Nonnull stop) {
		[obj resignFirstResponder];
	}];
}

- (UITextField *)usernameTextField {
	if (!_usernameTextField) {
		_usernameTextField = [HTLoginTextFieldGroupView normalTextField];
		_usernameTextField.placeholder = @" 请输入手机号/邮箱";
		UIImage *leftImage = [UIImage imageNamed:@"MineLogin4"];
		[((UIButton *)_usernameTextField.leftView) setImage:leftImage forState:UIControlStateNormal];
	}
	return _usernameTextField;
}

- (UITextField *)passwordTextField {
	if (!_passwordTextField) {
		_passwordTextField = [HTLoginTextFieldGroupView normalTextField];
		_passwordTextField.placeholder = @" 请输入密码";
		_passwordTextField.secureTextEntry = true;
		UIImage *leftImage = [UIImage imageNamed:@"MineLogin5"];
		[((UIButton *)_passwordTextField.leftView) setImage:leftImage forState:UIControlStateNormal];
	}
	return _passwordTextField;
}

- (UITextField *)surePasswordTextField {
	if (!_surePasswordTextField) {
		_surePasswordTextField = [HTLoginTextFieldGroupView normalTextField];
		_surePasswordTextField.secureTextEntry = true;
		_surePasswordTextField.placeholder = @" 请确认密码";
	}
	return _surePasswordTextField;
}

- (UITextField *)phoneEmailTextField {
	if (!_phoneEmailTextField) {
		_phoneEmailTextField = [HTLoginTextFieldGroupView normalTextField];
		_phoneEmailTextField.placeholder = @" 请输入手机号/邮箱";
		UIImage *leftImage = [UIImage imageNamed:@"MineLogin6"];
		[((UIButton *)_phoneEmailTextField.leftView) setImage:leftImage forState:UIControlStateNormal];
	}
	return _phoneEmailTextField;
}

- (UITextField *)messageCodeTextFiled {
	if (!_messageCodeTextFiled) {
		_messageCodeTextFiled = [HTLoginTextFieldGroupView normalTextField];
		_messageCodeTextFiled.placeholder = @" 请输入验证码";
		_messageCodeTextFiled.rightView = self.messageCodeButton;
		_messageCodeTextFiled.rightViewMode = UITextFieldViewModeAlways;
	}
	return _messageCodeTextFiled;
}

- (UIButton *)messageCodeButton {
	if (!_messageCodeButton) {
		_messageCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_messageCodeButton.frame = CGRectMake(0, 0, HTADAPT568(70), HTADAPT568(25));
		[_messageCodeButton setBackgroundImage:[UIImage ht_pureColor:[UIColor colorWithWhite:0 alpha:0.5]] forState:UIControlStateNormal];
		[_messageCodeButton setBackgroundImage:[UIImage ht_pureColor:[UIColor ht_colorStyle:HTColorStylePrimarySeparate]] forState:UIControlStateDisabled];
		_messageCodeButton.layer.cornerRadius = 3;
		_messageCodeButton.layer.masksToBounds = true;
		[_messageCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
		_messageCodeButton.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleDetailLarge];
		
		__weak HTLoginTextFieldGroupView *weakSelf = self;
		[_messageCodeButton ht_whenTap:^(UIView *view) {
			
			if (!([HTValidateManager ht_validateMobile:weakSelf.phoneEmailTextField.text] || [HTValidateManager ht_validateEmail:weakSelf.phoneEmailTextField.text])) {
				[HTAlert title:@"手机号或邮箱格式不大对哦"];
				return;
			}
			
			HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
			networkModel.autoAlertString = @"验证码发送中";
			networkModel.offlineCacheStyle = HTCacheStyleNone;
			networkModel.autoShowError = true;
			[HTRequestManager requestRegisterOrForgetPasswordOrUpdataUserMessageCodeWithNetworkModel:networkModel phoneOrEmailString:weakSelf.phoneEmailTextField.text requestMessageCodeStyle:weakSelf.textFieldGroupType complete:^(id response, HTError *errorModel) {
				if (errorModel.existError) {
					return;
				}
				[HTAlert title:@"验证码已发送"];
				weakSelf.messageCodeButton.enabled = false;
				[weakSelf.messageCodeTextFiled becomeFirstResponder];
				[weakSelf.messageCodeButton setTitle:@"59" forState:UIControlStateNormal];
				[weakSelf.timer invalidate];
				weakSelf.timer = [NSTimer bk_timerWithTimeInterval:1 block:^(NSTimer *timer) {
					NSInteger currentTime = [[weakSelf.messageCodeButton titleForState:UIControlStateNormal] integerValue];
					[weakSelf.messageCodeButton setTitle:[NSString stringWithFormat:@"%ld", currentTime - 1]  forState:UIControlStateNormal];
					if ([[weakSelf.messageCodeButton titleForState:UIControlStateNormal] isEqualToString:@"0"]) {
						weakSelf.messageCodeButton.enabled = true;
						[weakSelf.messageCodeButton setTitle:@"验证码" forState:UIControlStateNormal];
						[weakSelf.timer invalidate];
					}
				} repeats:true];
				[[NSRunLoop currentRunLoop] addTimer:weakSelf.timer forMode:NSRunLoopCommonModes];
			}];
		}];
	}
	return _messageCodeButton;
}

+ (UITextField *)normalTextField {
	UITextField *textField = [[UITextField alloc] init];
	textField.clearButtonMode = UITextFieldViewModeWhileEditing;
	UIButton *leftView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, HTADAPT568(30), 40)];
	textField.leftView = leftView;
	textField.leftViewMode = UITextFieldViewModeAlways;
	textField.keyboardType = UIKeyboardTypeAlphabet;
	textField.keyboardAppearance = UIKeyboardAppearanceDark;
	textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	textField.autocorrectionType = UITextAutocorrectionTypeNo;
	textField.spellCheckingType = UITextSpellCheckingTypeNo;
	textField.backgroundColor = [UIColor clearColor];
	textField.textColor = [UIColor whiteColor];
	textField.font = [UIFont ht_fontStyle:HTFontStyleTitleLarge];
	textField.tintColor = [UIColor whiteColor];
	
	__weak UITextField *weakTextField = textField;
	[textField bk_addObserverForKeyPath:@"placeholder" options:NSKeyValueObservingOptionInitial task:^(id obj, NSDictionary *change) {
		if (weakTextField.placeholder) {
			weakTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:weakTextField.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:1 alpha:0.8], NSFontAttributeName:weakTextField.font}];
		}
	}];
	return textField;
}

@end
