//
//  HTLoginController.m
//  GMat
//
//  Created by hublot on 2016/10/19.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTLoginController.h"
#import <UITableView+HTSeparate.h>
#import "HTLoginTextFieldGroupView.h"
#import <HTValidateManager.h>
#import "HTLoginPushGroupView.h"
#import "HTLoginManager.h"
#import "HTCenterLabelAlert.h"
#import "HTRegisterController.h"
#import "HTForgetPasswordController.h"

@interface HTLoginController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *logoImageView;

@property (nonatomic, strong) UITableView *textFieldTableView;

@property (nonatomic, strong) HTLoginTextFieldGroupView *textFieldGroupView;

@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) HTLoginPushGroupView *pushGroupView;

@end

@implementation HTLoginController

- (void)dealloc {
	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	self.textFieldGroupView.usernameTextField.text = [HTLoginManager userDefaultsUserName];
	self.textFieldGroupView.passwordTextField.text = [HTLoginManager userDefaultsPassword];
	[self validateInputGuard];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	self.automaticallyAdjustsScrollViewInsets = false;
	if (@available(iOS 11.0, *)) {
		self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}
	[self.view addSubview:self.tableView];
	UIImage *backgroundImage = [[UIImage imageNamed:@"LoginBackground"] ht_applyDarkEffect];
	backgroundImage = [backgroundImage ht_croppedAtRect:CGRectInset(CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height), 5, 5)];
	UIImageView *backgrundImageView = [[UIImageView alloc] initWithImage:backgroundImage];

	UIImageView *darkAlphaImageView = [[UIImageView alloc] initWithFrame:backgrundImageView.bounds];
	darkAlphaImageView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.15];
	[UIView animateWithDuration:2 animations:^{
		darkAlphaImageView.alpha = 0;
	} completion:nil];
	[backgrundImageView addSubview:darkAlphaImageView];
	
	self.tableView.backgroundView = backgrundImageView;
	[self.tableView addSubview:self.logoImageView];
	[self.tableView addSubview:self.textFieldTableView];
	[self.tableView addSubview:self.loginButton];
	[self.tableView addSubview:self.pushGroupView];
	__weak HTLoginController *weakSelf = self;
	[self ht_addFallowKeyBoardView:self.view style:HTKeyBoardStylePoint customKeyBoardHeight:^CGFloat(HTKeyboardModel *fallowModel, CGFloat originHeight, CGFloat duration) {
		return MAX(0, originHeight - (weakSelf.view.ht_h - weakSelf.pushGroupView.ht_y - weakSelf.pushGroupView.ht_h)) + 30;
	}];
	[self.pushGroupView.forgetPasswordButton ht_whenTap:^(UIView *view) {
		HTForgetPasswordController *forgetPasswordController = [[HTForgetPasswordController alloc] init];
		[weakSelf.navigationController pushViewController:forgetPasswordController animated:true];
	}];
	[self.pushGroupView.handRisterButton ht_whenTap:^(UIView *view) {
		HTRegisterController *registerController = [[HTRegisterController alloc] init];
		[weakSelf.navigationController pushViewController:registerController animated:true];
	}];
//	[self.pushGroupView.loginByQQButton ht_whenTap:^(UIView *view) {
//		[HTLoginManager loginWithThreeLoginStyle:SSDKPlatformTypeQQ complete:^(BOOL success, NSString *alertString) {
//			if (success) {
//				[weakSelf dismissViewControllerAnimated:true completion:nil];
//			}
//		}];
//	}];
}

- (void)validateInputGuard {
	self.loginButton.selected = !(([HTValidateManager ht_validateMobile:self.textFieldGroupView.usernameTextField.text] || [HTValidateManager ht_validateEmail:self.textFieldGroupView.usernameTextField.text] || [HTValidateManager ht_validateUserName:self.textFieldGroupView.usernameTextField.text]) && [HTValidateManager ht_validatePassword:self.textFieldGroupView.passwordTextField.text]);
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
		_tableView.contentInset = UIEdgeInsetsZero;
		_tableView.scrollIndicatorInsets = _tableView.contentInset;
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
		__weak HTLoginController *weakSelf = self;
		[_tableView ht_whenTap:^(UIView *view) {
			[weakSelf.textFieldGroupView resignFirstResponder];
		}];
	}
	return _tableView;
}

- (UIImageView *)logoImageView {
	if (!_logoImageView) {
		_logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MineLogin3"]];
		_logoImageView.center = CGPointMake(self.tableView.ht_w / 2, _logoImageView.ht_h / 2 + HTADAPT568(70));
	}
	return _logoImageView;
}


- (UITableView *)textFieldTableView {
	if (!_textFieldTableView) {
		_textFieldTableView = [[UITableView alloc] initWithFrame:CGRectMake(HTADAPT568(40), HTADAPT568(230), self.tableView.ht_w - HTADAPT568(40) * 2, HTADAPT568(40) * 2 - 1)];
		_textFieldTableView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.3];
		_textFieldTableView.layer.cornerRadius = 3;
		_textFieldTableView.layer.masksToBounds = true;
		_textFieldTableView.allowsSelection = false;
		_textFieldTableView.scrollEnabled = false;
		NSArray *textFiedlArray = @[self.textFieldGroupView.usernameTextField, self.textFieldGroupView.passwordTextField];
        
        [_textFieldTableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [sectionMaker.rowHeight(HTADAPT568(40))
			 .modelArray(textFiedlArray) customCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof UIView *model) {
                cell.backgroundColor = [UIColor clearColor];
                [cell addSubview:model];
                [model mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(0, 15, 0, 15));
                }];
            }];
        }];
	}
	return _textFieldTableView;
}

- (HTLoginTextFieldGroupView *)textFieldGroupView {
	if (!_textFieldGroupView) {
		_textFieldGroupView = [[HTLoginTextFieldGroupView alloc] init];
		_textFieldGroupView.usernameTextField.text = [HTLoginManager userDefaultsUserName];
		_textFieldGroupView.passwordTextField.text = [HTLoginManager userDefaultsPassword];
	}
	return _textFieldGroupView;
}

- (UIButton *)loginButton {
	if (!_loginButton) {
		_loginButton = [[UIButton alloc] initWithFrame:CGRectMake(self.textFieldTableView.ht_x, self.textFieldTableView.ht_y + self.textFieldTableView.ht_h + 20, self.textFieldTableView.ht_w, HTADAPT568(35))];
		[_loginButton setBackgroundImage:[UIImage ht_pureColor:[UIColor ht_colorStyle:HTColorStyleAnswerRight]] forState:UIControlStateNormal];
		[_loginButton setBackgroundImage:[UIImage ht_pureColor:[UIColor colorWithWhite:0.4 alpha:0.3]] forState:UIControlStateSelected];
		_loginButton.selected = true;
		_loginButton.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleHeadSmall];
		[_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[_loginButton setTitle:@"登录" forState:UIControlStateNormal];
		_loginButton.layer.cornerRadius = 3;
		_loginButton.layer.masksToBounds = true;
		__weak HTLoginController *weakSelf = self;
		[_loginButton ht_whenTap:^(UIView *view) {
			if (weakSelf.loginButton.selected) {
				if (!([HTValidateManager ht_validateMobile:weakSelf.textFieldGroupView.usernameTextField.text] || [HTValidateManager ht_validateEmail:weakSelf.textFieldGroupView.usernameTextField.text] || [HTValidateManager ht_validateUserName:weakSelf.textFieldGroupView.usernameTextField.text])) {
					HTCenterLabelAlert *centerLabelAlert = [HTAlert centerTitle:@"手机号或者邮箱格式不对哦"];
					centerLabelAlert.ht_cy = (weakSelf.textFieldTableView.ht_y - weakSelf.logoImageView.ht_y - weakSelf.logoImageView.ht_h) / 2 + (weakSelf.logoImageView.ht_y + weakSelf.logoImageView.ht_h);
					[weakSelf.tableView addSubview:centerLabelAlert];
				} else if (![HTValidateManager ht_validatePassword:weakSelf.textFieldGroupView.passwordTextField.text]) {
					HTCenterLabelAlert *centerLabelAlert = [HTAlert centerTitle:@"密码格式有误, 6-20个字符, 支持数字和大小写字母"];
					centerLabelAlert.ht_cy = (weakSelf.textFieldTableView.ht_y - weakSelf.logoImageView.ht_y - weakSelf.logoImageView.ht_h) / 2 + (weakSelf.logoImageView.ht_y + weakSelf.logoImageView.ht_h);
					[weakSelf.tableView addSubview:centerLabelAlert];
				}
			} else {
				[HTLoginManager loginUsername:weakSelf.textFieldGroupView.usernameTextField.text password:weakSelf.textFieldGroupView.passwordTextField.text alert:true complete:^(BOOL success, NSString *alertString) {
					if (success) {
						[weakSelf dismissViewControllerAnimated:true completion:nil];
					} else {
//						HTCenterLabelAlert *centerLabelAlert = [HTAlert centerTitle:alertString];
//						centerLabelAlert.ht_cy = (weakSelf.textFieldTableView.ht_y - weakSelf.logoImageView.ht_y - weakSelf.logoImageView.ht_h) / 2 + (weakSelf.logoImageView.ht_y + weakSelf.logoImageView.ht_h);
//						[weakSelf.tableView addSubview:centerLabelAlert];
					}
				}];
			}
		}];
		[self.textFieldGroupView.usernameTextField bk_addEventHandler:^(id sender) {
			[weakSelf validateInputGuard];
		} forControlEvents:UIControlEventEditingChanged];
		[self.textFieldGroupView.passwordTextField bk_addEventHandler:^(id sender) {
			[weakSelf validateInputGuard];
		} forControlEvents:UIControlEventEditingChanged];
	}
	return _loginButton;
}

- (HTLoginPushGroupView *)pushGroupView {
	if (!_pushGroupView) {
		_pushGroupView = [[HTLoginPushGroupView alloc] initWithFrame:CGRectMake(self.loginButton.ht_x, self.loginButton.ht_y + self.loginButton.ht_h + 20, self.loginButton.ht_w, 40)];
	}
	return _pushGroupView;
}


@end
