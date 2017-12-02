//
//  HTForgetPasswordController.m
//  GMat
//
//  Created by hublot on 2016/10/31.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTForgetPasswordController.h"
#import "HTLoginController.h"
#import "HTLoginTextFieldGroupView.h"
#import <UITableView+HTSeparate.h>
#import <HTValidateManager.h>
#import "HTLoginManager.h"


@interface HTForgetPasswordController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITableView *textFieldTableView;

@property (nonatomic, strong) HTLoginTextFieldGroupView *textFieldGroupView;

@property (nonatomic, strong) UIButton *sureButton;

@end

@implementation HTForgetPasswordController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
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
	self.tableView.backgroundView = backgrundImageView;
	UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MineLogin3"]];
	logoImageView.center = CGPointMake(self.tableView.ht_w / 2, logoImageView.ht_h / 2 + HTADAPT568(50));
	[self.tableView addSubview:logoImageView];
	[self.tableView addSubview:self.textFieldTableView];
	[self.tableView addSubview:self.sureButton];
	__weak HTForgetPasswordController *weakSelf = self;
	[self ht_addFallowKeyBoardView:self.view style:HTKeyBoardStylePoint customKeyBoardHeight:^CGFloat(HTKeyboardModel *fallowModel, CGFloat originHeight, CGFloat duration) {
		return MAX(0, originHeight - (weakSelf.view.ht_h - weakSelf.sureButton.ht_y - weakSelf.sureButton.ht_h)) + 30;
	}];
}

- (NSDictionary *)validateInputGuard {
	NSDictionary *registerValidata;
	if (!([HTValidateManager ht_validateMobile:self.textFieldGroupView.phoneEmailTextField.text] || [HTValidateManager ht_validateEmail:self.textFieldGroupView.phoneEmailTextField.text])) {
		registerValidata = @{@"手机号或邮箱格式不大对哦":@""};
	} else if (!self.textFieldGroupView.messageCodeTextFiled.hasText) {
		registerValidata = @{@"你还没有填写验证码":@""};
	} else if (![HTValidateManager ht_validatePassword:self.textFieldGroupView.passwordTextField.text]) {
		registerValidata = @{@"密码格式不大对哦":@"6-20个字符, 支持数字和大小写字母"};
	} else if (![self.textFieldGroupView.passwordTextField.text isEqualToString:self.textFieldGroupView.surePasswordTextField.text]) {
		registerValidata = @{@"两次密码不一致哦":@""};
	}
	self.sureButton.selected = registerValidata.count;
	return registerValidata;
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.ht_w, self.view.ht_h)];
		_tableView.contentInset = UIEdgeInsetsZero;
		_tableView.scrollIndicatorInsets = _tableView.contentInset;
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
		__weak HTForgetPasswordController *weakSelf = self;
		[_tableView ht_whenTap:^(UIView *view) {
			[weakSelf.textFieldGroupView resignFirstResponder];
		}];
	}
	return _tableView;
}

- (UITableView *)textFieldTableView {
	if (!_textFieldTableView) {
		_textFieldTableView = [[UITableView alloc] initWithFrame:CGRectMake(HTADAPT568(40), HTADAPT568(200), self.tableView.ht_w - HTADAPT568(40) * 2, HTADAPT568(40) * 4 - 1)];
		_textFieldTableView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.3];
		_textFieldTableView.layer.cornerRadius = 3;
		_textFieldTableView.layer.masksToBounds = true;
		_textFieldTableView.allowsSelection = false;
		_textFieldTableView.scrollEnabled = false;
		NSArray *textFiedlArray = @[self.textFieldGroupView.phoneEmailTextField, self.textFieldGroupView.messageCodeTextFiled, self.textFieldGroupView.passwordTextField, self.textFieldGroupView.surePasswordTextField];
        
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
		_textFieldGroupView.textFieldGroupType = HTLoginTextFieldGroupTypeForgetPassword;
	}
	return _textFieldGroupView;
}

- (UIButton *)sureButton {
	if (!_sureButton) {
		_sureButton = [[UIButton alloc] initWithFrame:CGRectMake(self.textFieldTableView.ht_x, self.textFieldTableView.ht_y + self.textFieldTableView.ht_h + 20, self.textFieldTableView.ht_w, HTADAPT568(35))];
		[_sureButton setBackgroundImage:[UIImage ht_pureColor:[UIColor ht_colorStyle:HTColorStyleAnswerRight]] forState:UIControlStateNormal];
		[_sureButton setBackgroundImage:[UIImage ht_pureColor:[UIColor colorWithWhite:0.4 alpha:0.3]] forState:UIControlStateSelected];
		_sureButton.selected = true;
		_sureButton.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleHeadSmall];
		[_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[_sureButton setTitle:@"确定" forState:UIControlStateNormal];
		_sureButton.layer.cornerRadius = 3;
		_sureButton.layer.masksToBounds = true;
		
		__weak HTForgetPasswordController *weakSelf = self;
		[self.textFieldGroupView.phoneEmailTextField bk_addEventHandler:^(id sender) {
			[weakSelf validateInputGuard];
		} forControlEvents:UIControlEventEditingChanged];
		[self.textFieldGroupView.messageCodeTextFiled bk_addEventHandler:^(id sender) {
			[weakSelf validateInputGuard];
		} forControlEvents:UIControlEventEditingChanged];
		[self.textFieldGroupView.passwordTextField bk_addEventHandler:^(id sender) {
			[weakSelf validateInputGuard];
		} forControlEvents:UIControlEventEditingChanged];
		[self.textFieldGroupView.surePasswordTextField bk_addEventHandler:^(id sender) {
			[weakSelf validateInputGuard];
		} forControlEvents:UIControlEventEditingChanged];
		[_sureButton ht_whenTap:^(UIView *view) {
			if (weakSelf.sureButton.selected) {
				[[weakSelf validateInputGuard] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
					if (obj.length) {
						[HTAlert title:key message:obj];
					} else {
						[HTAlert title:key];
					}
					*stop = true;
				}];
			} else {
				NSString *forgetType = @"1";
				if ([HTValidateManager ht_validateMobile:weakSelf.textFieldGroupView.phoneEmailTextField.text]) {
					forgetType = @"1";
				} else if ([HTValidateManager ht_validateEmail:weakSelf.textFieldGroupView.phoneEmailTextField.text]) {
					forgetType = @"2";
				}
				HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
				networkModel.autoAlertString = @"重置密码中";
				networkModel.offlineCacheStyle = HTCacheStyleNone;
				networkModel.autoShowError = true;
				[HTRequestManager requestResetPasswordWithNetworkModel:networkModel phoneOrEmailString:weakSelf.textFieldGroupView.phoneEmailTextField.text resetPassword:weakSelf.textFieldGroupView.passwordTextField.text messageCode:weakSelf.textFieldGroupView.messageCodeTextFiled.text complete:^(id response, HTError *errorModel) {
					if (errorModel.existError) {
						return;
					}
					[HTAlert title:@"重置密码成功"];
					[HTLoginManager loginUsername:weakSelf.textFieldGroupView.phoneEmailTextField.text
										 password:weakSelf.textFieldGroupView.passwordTextField.text
											alert:false
										 complete:^(BOOL success, NSString *alertString) {
											 if (success) {
												 [weakSelf dismissViewControllerAnimated:true completion:nil];
											 } else {
												 [weakSelf.navigationController popViewControllerAnimated:true];
											 }
										 }];
				}];
			}
		}];
	}
	return _sureButton;
}

@end
