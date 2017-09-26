//
//  THMinePreferenceInputController.m
//  TingApp
//
//  Created by hublot on 16/9/1.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "THMinePreferenceInputController.h"
#import <UITableView+HTSeparate.h>
#import "THTableButton.h"
#import "THMinePreferenceInputCell.h"
#import "HTLoginManager.h"
#import <HTValidateManager.h>
#import "KeychainWrapper.h"


@interface THMinePreferenceInputController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *primaryTextField;

@property (nonatomic, strong) UITextField *secondTextField;

@property (nonatomic, strong) UIButton *messageCodeButton;

@property (nonatomic, strong) THTableButton *sureButton;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation THMinePreferenceInputController

- (void)dealloc {
	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    [self.timer invalidate];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	NSArray *titleArray = @[@"昵称", @"电话", @"邮箱", @"密码"];
	NSArray *primaryPlaceHolderArray = @[@" 请输入昵称", @" 请输入电话", @" 请输入邮箱", @" 请输入旧密码"];
	NSArray *secondPlaceHolerArray = @[@"", @" 请输入验证码", @" 请输入验证码", @" 请输入新密码"];
	NSArray *primaryText = @[[HTUserManager currentUser].nickname, [HTUserManager currentUser].phone, [HTUserManager currentUser].useremail, @""];
	NSArray *secondText = @[@"", @"", @"", @""];
	self.navigationItem.title = titleArray[self.inputStyle];
	[self.view addSubview:self.tableView];
    __weak THMinePreferenceInputController *weakSelf = self;
    [self.tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
        [sectionMaker.cellClass([THMinePreferenceInputCell class])
		 .modelArray(weakSelf.inputStyle == THMinePreferenceInputName ? @[@"", @""] : @[@"", @"", @""])
		 .rowHeight(65) customCellBlock:^(UITableView *tableView, NSInteger row, UITableViewCell *cell, id model) {
            if (weakSelf.inputStyle == THMinePreferenceInputName && row == 1) {
                row = 2;
            }
            if (row == 0) {
                [cell addSubview:weakSelf.primaryTextField];
                weakSelf.primaryTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:primaryPlaceHolderArray[weakSelf.inputStyle] attributes:@{NSFontAttributeName:weakSelf.primaryTextField.font, NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStyleSecondaryTitle]}];
                weakSelf.primaryTextField.text = primaryText[weakSelf.inputStyle];
                [weakSelf.primaryTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsZero);
                }];
                if (weakSelf.inputStyle == THMinePreferenceInputName) {
                    weakSelf.primaryTextField.keyboardType = UIKeyboardTypeDefault;
                } else if (weakSelf.inputStyle == THMinePreferenceInputPassword) {
                    weakSelf.primaryTextField.secureTextEntry = true;
                }
            } else if (row == 1) {
                [cell addSubview:weakSelf.secondTextField];
                weakSelf.secondTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:secondPlaceHolerArray[weakSelf.inputStyle] attributes:@{NSFontAttributeName:weakSelf.secondTextField.font, NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStyleSecondaryTitle]}];
                weakSelf.secondTextField.text = secondText[weakSelf.inputStyle];
                [weakSelf.secondTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.bottom.mas_equalTo(cell);
                    make.width.mas_equalTo(cell).multipliedBy(weakSelf.inputStyle != THMinePreferenceInputPassword ? 0.6 : 1);
                }];
                if (weakSelf.inputStyle != THMinePreferenceInputPassword) {
                    [cell addSubview:weakSelf.messageCodeButton];
                    [weakSelf.messageCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.mas_equalTo(cell);
                        make.left.mas_equalTo(weakSelf.secondTextField.mas_right).offset(10);
                        make.top.mas_equalTo(cell).offset(2);
                        make.bottom.mas_equalTo(cell).offset(- 2);
                    }];
                } else {
                    weakSelf.secondTextField.secureTextEntry = true;
                }
            } else {
                [cell addSubview:weakSelf.sureButton];
                [weakSelf.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(2, 0, 2, 0));
                }];
            }
        }];
    }];
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
		_tableView.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
		_tableView.allowsSelection = false;
        __weak THMinePreferenceInputController *weakSelf = self;
		[_tableView ht_whenTap:^(UIView *view) {
			[weakSelf.primaryTextField resignFirstResponder];
			[weakSelf.secondTextField resignFirstResponder];
		}];
	}
	return _tableView;
}

- (UIButton *)messageCodeButton {
	if (!_messageCodeButton) {
		_messageCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_messageCodeButton.frame = CGRectMake(0, 0, 100, 45);
		[_messageCodeButton setBackgroundImage:[UIImage ht_pureColor:[UIColor ht_colorStyle:HTColorStyleSpecialTheme]] forState:UIControlStateNormal];
		[_messageCodeButton setBackgroundImage:[UIImage ht_pureColor:[UIColor ht_colorStyle:HTColorStylePrimarySeparate]] forState:UIControlStateDisabled];
		_messageCodeButton.layer.cornerRadius = 3;
		_messageCodeButton.layer.masksToBounds = true;
		[_messageCodeButton setTitle:@"验证码" forState:UIControlStateNormal];
		_messageCodeButton.titleLabel.font = [UIFont systemFontOfSize:15];
        __weak THMinePreferenceInputController *weakSelf = self;
		[_messageCodeButton ht_whenTap:^(UIView *view) {
			if (weakSelf.inputStyle == THMinePreferenceInputName) {
				if (![weakSelf checkPhone]) {
					return;
				}
			} else if (weakSelf.inputStyle == THMinePreferenceInputEmail) {
				if (![weakSelf checkEmail]) {
					return;
				}
			}
			HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
			networkModel.autoAlertString = @"获取验证码中";
			networkModel.offlineCacheStyle = HTCacheStyleNone;
			networkModel.autoShowError = true;
			[HTRequestManager requestRegisterOrForgetPasswordOrUpdataUserMessageCodeWithNetworkModel:networkModel phoneOrEmailString:weakSelf.primaryTextField.text requestMessageCodeStyle:HTLoginTextFieldGroupTypeChangeUser complete:^(id response, HTError *errorModel) {
				if (errorModel.existError) {
					return;
				}
				[HTAlert title:@"验证码已发送"];
				weakSelf.messageCodeButton.enabled = false;
				[weakSelf.secondTextField becomeFirstResponder];
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

- (BOOL)checkUsername {
	if (![HTValidateManager ht_validateNickname:self.primaryTextField.text]) {
		[HTAlert title:@"昵称格式不大对哦" message:@"2-8个字符, 不能包含特殊字符"];
		return false;
	} else if ([self.primaryTextField.text isEqualToString:[HTUserManager currentUser].nickname]) {
		[HTAlert title:@"这是目前昵称"];
		return false;
	}
	return true;
}

- (BOOL)checkPhone {
	if(![HTValidateManager ht_validateMobile:self.primaryTextField.text]) {
		[HTAlert title:@"手机号格式不大对哦"];
		return false;
	} else if([self.primaryTextField.text isEqualToString:[HTUserManager currentUser].phone]) {
		[HTAlert title:@"你已经绑定过该手机号了哦"];
		return false;
	}
	return true;
}

- (BOOL)checkEmail {
	if (![HTValidateManager ht_validateEmail:self.primaryTextField.text]) {
		[HTAlert title:@"邮箱格式不大对哦"];
		return false;
	} else if ([self.primaryTextField.text isEqualToString:[HTUserManager currentUser].useremail]) {
		[HTAlert title:@"你已经绑定过该邮箱了哦"];
		return false;
	}
	return true;
}

- (BOOL)checkPassword {
	if (![HTValidateManager ht_validatePassword:self.primaryTextField.text]) {
		[HTAlert title:@"原密码格式不大对哦" message:@"6-20个字符, 支持数字和大小写字母"];
		return false;
	} else if (![HTValidateManager ht_validatePassword:self.secondTextField.text]) {
		[HTAlert title:@"新密码格式不大对哦" message:@"6-20个字符, 支持数字和大小写字母"];
		return false;
	} else if ([self.primaryTextField.text isEqualToString:self.secondTextField.text]) {
		[HTAlert title:@"原密码和新密码不能相同"];
		return false;
	}
	return true;
}

- (BOOL)checkMessageCode {
	if (!self.secondTextField.text.length) {
		return false;
	}
	return true;
}

- (UITextField *)primaryTextField {
	if (!_primaryTextField) {
		_primaryTextField = [[UITextField alloc] init];
		_primaryTextField.backgroundColor = [UIColor whiteColor];
		_primaryTextField.layer.cornerRadius = 3;
		_primaryTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
		_primaryTextField.leftViewMode = UITextFieldViewModeAlways;
		_primaryTextField.keyboardType = UIKeyboardTypeASCIICapable;
		_primaryTextField.keyboardAppearance = UIKeyboardAppearanceDark;
		_primaryTextField.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_primaryTextField.font = [UIFont systemFontOfSize:15];
		_primaryTextField.layer.borderWidth = 1;
		_primaryTextField.layer.borderColor = [UIColor ht_colorStyle:HTColorStylePrimarySeparate].CGColor;
		_primaryTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		_primaryTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
		_primaryTextField.autocorrectionType = UITextAutocorrectionTypeNo;
		_primaryTextField.spellCheckingType = UITextSpellCheckingTypeNo;
	}
	return _primaryTextField;
}

- (UITextField *)secondTextField {
	if (!_secondTextField) {
		NSData *tempData = [NSKeyedArchiver archivedDataWithRootObject:self.primaryTextField];
		_secondTextField = [NSKeyedUnarchiver unarchiveObjectWithData:tempData];
		_secondTextField.layer.cornerRadius = 3;
		_secondTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
		_secondTextField.leftViewMode = UITextFieldViewModeAlways;
		_secondTextField.layer.borderWidth = 1;
		_secondTextField.layer.borderColor = [UIColor ht_colorStyle:HTColorStylePrimarySeparate].CGColor;
		_secondTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	}
	return _secondTextField;
}

- (void)changeSuccess {
	if (self.inputStyle == THMinePreferenceInputPassword) {
		[HTAlert title:@"你已修改密码, 请重新登录"];
		[self.navigationController popToRootViewControllerAnimated:false];
		[HTLoginManager exitLoginWithComplete:^{
			[HTLoginManager presentAndLoginSuccess:nil];
		}];
	} else {
        __weak THMinePreferenceInputController *weakSelf = self;
		NSString *username = [HTLoginManager userDefaultsUserName];
		NSString *password = [HTLoginManager userDefaultsPassword];
		[HTLoginManager exitLoginWithComplete:^{
			[HTLoginManager loginUsername:username password:password alert:true complete:^(BOOL success, NSString *alertString) {
				[weakSelf.navigationController popToRootViewControllerAnimated:false];
				if (!success) {
					[HTAlert title:@"修改成功, 登录重置信息失败了, 请手动登录"];
					[HTLoginManager presentAndLoginSuccess:nil];
				}
			}];
		}];
	}
}

- (THTableButton *)sureButton {
	if (!_sureButton) {
		_sureButton = [[THTableButton alloc] initWithFrame:CGRectMake(0, 0, self.view.ht_w - 80, 45)];
		[_sureButton setTitle:@"确定" forState:UIControlStateNormal];
		_sureButton.layer.cornerRadius = 3;
		_sureButton.layer.masksToBounds = true;
        __weak THMinePreferenceInputController *weakSelf = self;
		[_sureButton ht_whenTap:^(UIView *view) {
			HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
			networkModel.autoAlertString = @"更改用户信息中";
			networkModel.offlineCacheStyle = HTCacheStyleNone;
			networkModel.autoShowError = true;
			
			HTUserTaskCompleteBlock complete = ^(id response, HTError *error){
				if (error.existError) {
					return;
				}
				[weakSelf changeSuccess];
			};
			
			if (weakSelf.inputStyle == THMinePreferenceInputName) {
				if (![weakSelf checkUsername]) {
					return;
				}
				[HTRequestManager requestUpdateUserNicknameWithNetworkModel:networkModel changeNickname:weakSelf.primaryTextField.text complete:complete];
			} else if (weakSelf.inputStyle == THMinePreferenceInputPhone) {
				if (![weakSelf checkPhone] || ![weakSelf checkMessageCode]) {
					return;
				}
				[HTRequestManager requestUpdateUserPhoneWithNetworkModel:networkModel changePhone:weakSelf.primaryTextField.text messageCode:weakSelf.secondTextField.text complete:complete];
			} else if (weakSelf.inputStyle == THMinePreferenceInputEmail) {
				if (![weakSelf checkEmail] || ![weakSelf checkMessageCode]) {
					return;
				}
				[HTRequestManager requestUpdateUserEmailWithNetworkModel:networkModel changeEmail:weakSelf.primaryTextField.text messageCode:weakSelf.secondTextField.text complete:complete];
			} else if (weakSelf.inputStyle == THMinePreferenceInputPassword) {
				if (![weakSelf checkPassword]) {
					return;
				}
				[HTRequestManager requestUpdateUserPasswordWithNetworkModel:networkModel originPassword:weakSelf.primaryTextField.text changePassword:weakSelf.secondTextField.text complete:complete];
			}
		}];
	}
	return _sureButton;
}


@end
