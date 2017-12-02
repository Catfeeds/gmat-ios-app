//
//  HTRegisterController.m
//  GMat
//
//  Created by hublot on 2016/10/31.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTRegisterController.h"
#import "HTLoginTextFieldGroupView.h"
#import <UITableView+HTSeparate.h>
#import <HTValidateManager.h>
#import "HTLoginManager.h"
#import <UIButton+HTButtonCategory.h>
#import "HTPreviewController.h"

@interface HTRegisterController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITableView *textFieldTableView;

@property (nonatomic, strong) HTLoginTextFieldGroupView *textFieldGroupView;

@property (nonatomic, strong) UIButton *registerButton;

@property (nonatomic, strong) UIButton *checkBoxButton;

@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation HTRegisterController

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
	[self.tableView addSubview:self.registerButton];
	[self.tableView addSubview:self.checkBoxButton];
	[self.tableView addSubview:self.loginButton];
	__weak HTRegisterController *weakSelf = self;
	[self ht_addFallowKeyBoardView:self.view style:HTKeyBoardStylePoint customKeyBoardHeight:^CGFloat(HTKeyboardModel *fallowModel, CGFloat originHeight, CGFloat duration) {
		return MAX(0, originHeight - (weakSelf.view.ht_h - weakSelf.loginButton.ht_y - weakSelf.loginButton.ht_h)) + 30;
	}];
}

- (NSDictionary *)validateInputGuard {
	NSDictionary *registerValidata;
	if (!([HTValidateManager ht_validateMobile:self.textFieldGroupView.phoneEmailTextField.text] || [HTValidateManager ht_validateEmail:self.textFieldGroupView.phoneEmailTextField.text])) {
		registerValidata = @{@"手机号或邮箱格式不大对哦":@""};
	} else if (!self.textFieldGroupView.messageCodeTextFiled.hasText) {
		registerValidata = @{@"你还没有填写验证码":@""};
//	} else if (![HTValidateManager ht_validateUserName:self.textFieldGroupView.usernameTextField.text]) {
//		registerValidata = @{@"用户名格式不对哦":@"6-20个字符, 必须包含英文字母和数字"};
	} else if (![HTValidateManager ht_validatePassword:self.textFieldGroupView.passwordTextField.text]) {
		registerValidata = @{@"密码格式不大对哦":@"6-20个字符, 支持数字和大小写字母"};
	} else if (!self.checkBoxButton.selected) {
		registerValidata = @{@"还没有同意用户协议哦":@""};
	}
	self.registerButton.selected = registerValidata.count;
	return registerValidata;
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
		_tableView.contentInset = UIEdgeInsetsZero;
		_tableView.scrollIndicatorInsets = _tableView.contentInset;
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
		__weak HTRegisterController *weakSelf = self;
		[_tableView ht_whenTap:^(UIView *view) {
			[weakSelf.textFieldGroupView resignFirstResponder];
		}];
	}
	return _tableView;
}

- (UITableView *)textFieldTableView {
	if (!_textFieldTableView) {
		_textFieldTableView = [[UITableView alloc] initWithFrame:CGRectMake(HTADAPT568(40), HTADAPT568(200), self.tableView.ht_w - HTADAPT568(40) * 2, HTADAPT568(40) * 3 - 1)];
		_textFieldTableView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.3];
		_textFieldTableView.layer.cornerRadius = 3;
		_textFieldTableView.layer.masksToBounds = true;
		_textFieldTableView.allowsSelection = false;
		_textFieldTableView.scrollEnabled = false;
		NSArray *textFiedlArray = @[self.textFieldGroupView.phoneEmailTextField, self.textFieldGroupView.messageCodeTextFiled, self.textFieldGroupView.passwordTextField];
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
		_textFieldGroupView.textFieldGroupType = HTLoginTextFieldGroupTypeRegister;
	}
	return _textFieldGroupView;
}

- (UIButton *)registerButton {
	if (!_registerButton) {
		_registerButton = [[UIButton alloc] initWithFrame:CGRectMake(self.textFieldTableView.ht_x, self.textFieldTableView.ht_y + self.textFieldTableView.ht_h + 20, self.textFieldTableView.ht_w, HTADAPT568(35))];
		[_registerButton setBackgroundImage:[UIImage ht_pureColor:[UIColor ht_colorStyle:HTColorStyleAnswerRight]] forState:UIControlStateNormal];
		[_registerButton setBackgroundImage:[UIImage ht_pureColor:[UIColor colorWithWhite:0.4 alpha:0.3]] forState:UIControlStateSelected];
		_registerButton.selected = true;
		_registerButton.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleHeadSmall];
		[_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[_registerButton setTitle:@"注册" forState:UIControlStateNormal];
		_registerButton.layer.cornerRadius = 3;
		_registerButton.layer.masksToBounds = true;
		
		__weak HTRegisterController *weakSelf = self;
		[self.textFieldGroupView.phoneEmailTextField bk_addEventHandler:^(id sender) {
			[weakSelf validateInputGuard];
		} forControlEvents:UIControlEventEditingChanged];
		[self.textFieldGroupView.messageCodeTextFiled bk_addEventHandler:^(id sender) {
			[weakSelf validateInputGuard];
		} forControlEvents:UIControlEventEditingChanged];
		[self.textFieldGroupView.usernameTextField bk_addEventHandler:^(id sender) {
			[weakSelf validateInputGuard];
		} forControlEvents:UIControlEventEditingChanged];
		[self.textFieldGroupView.passwordTextField bk_addEventHandler:^(id sender) {
			[weakSelf validateInputGuard];
		} forControlEvents:UIControlEventEditingChanged];
		[_registerButton ht_whenTap:^(UIView *view) {
			if (weakSelf.registerButton.selected) {
				[[weakSelf validateInputGuard] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
					if (obj.length) {
						[HTAlert title:key message:obj];
					} else {
						[HTAlert title:key];
					}
					*stop = true;
				}];
			} else {
				NSString *registerType = @"1";
				if ([HTValidateManager ht_validateMobile:weakSelf.textFieldGroupView.phoneEmailTextField.text]) {
					registerType = @"1";
				} else if ([HTValidateManager ht_validateEmail:weakSelf.textFieldGroupView.phoneEmailTextField.text]) {
					registerType = @"2";
				}
				HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
				networkModel.autoAlertString = @"正在注册中";
				networkModel.offlineCacheStyle = HTCacheStyleNone;
				networkModel.autoShowError = true;
				[HTRequestManager requestRegisterWithNetworkModel:networkModel phoneOrEmailString:weakSelf.textFieldGroupView.phoneEmailTextField.text registerPassword:weakSelf.textFieldGroupView.passwordTextField.text messageCode:weakSelf.textFieldGroupView.messageCodeTextFiled.text usernameString:weakSelf.textFieldGroupView.usernameTextField.text complete:^(id response, HTError *errorModel) {
					if (errorModel.existError) {
						return;
					}
					[HTAlert title:@"注册成功"];
					[HTLoginManager loginUsername:weakSelf.textFieldGroupView.phoneEmailTextField.text password:weakSelf.textFieldGroupView.passwordTextField.text alert:true complete:^(BOOL success, NSString *alertString) {
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
	return _registerButton;
}

- (UIButton *)checkBoxButton {
	if (!_checkBoxButton) {
		_checkBoxButton = [[UIButton alloc] initWithFrame:CGRectMake(self.registerButton.ht_x, self.registerButton.ht_y + self.registerButton.ht_h + 25, self.registerButton.ht_w, 20)];
		
		_checkBoxButton.titleLabel.font = [UIFont systemFontOfSize:12];
		[_checkBoxButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[_checkBoxButton setTitle:@"已阅读并同意《用户协议》" forState:UIControlStateNormal];
		
		UIColor *color = [UIColor whiteColor];
		CGFloat imageLine = 12;
		CGFloat margin = 4;
		UIImage *normalImage = [UIImage ht_pureColor:[UIColor clearColor]];
		normalImage = [normalImage ht_resetSize:CGSizeMake(imageLine, imageLine)];
		normalImage = [normalImage ht_imageByRoundCornerRadius:imageLine / 2 corners:UIRectCornerAllCorners borderWidth:1 borderColor:color borderLineJoin:kCGLineJoinRound];
		
		UIImage *selectedImage = normalImage;
		UIImage *circelImage = [UIImage ht_pureColor:color];
		CGFloat circelLine = imageLine - margin * 2;
		circelImage = [circelImage ht_resetSize:CGSizeMake(circelLine, circelLine)];
		circelImage = [circelImage ht_imageByRoundCornerRadius:circelLine / 2 corners:UIRectCornerAllCorners borderWidth:0 borderColor:nil borderLineJoin:kCGLineJoinRound];
		selectedImage = [selectedImage ht_appendImage:circelImage atRect:CGRectMake(margin, margin, circelImage.size.width, circelImage.size.height)];
		
		[_checkBoxButton setImage:normalImage forState:UIControlStateNormal];
		[_checkBoxButton setImage:normalImage forState:UIControlStateNormal | UIControlStateHighlighted];
		
		[_checkBoxButton setImage:selectedImage forState:UIControlStateSelected];
		[_checkBoxButton setImage:selectedImage forState:UIControlStateSelected | UIControlStateHighlighted];
		
		[_checkBoxButton ht_makeEdgeWithDirection:HTButtonEdgeDirectionHorizontal imageViewToTitleLabelSpeceOffset:4];
		
		__weak typeof(self) weakSelf = self;
		[_checkBoxButton ht_whenTap:^(UIView *view) {
			UIGestureRecognizer *gesture = weakSelf.checkBoxButton.gestureRecognizers.lastObject;
			CGPoint point = [gesture locationInView:weakSelf.checkBoxButton];
			if (point.x <= weakSelf.checkBoxButton.titleLabel.ht_x) {
				weakSelf.checkBoxButton.selected = !weakSelf.checkBoxButton.selected;
				[weakSelf validateInputGuard];
			} else {
				HTPreviewController *previewController = [[HTPreviewController alloc] init];
				NSString *path = [[NSBundle mainBundle] pathForAuxiliaryExecutable:@"用户协议.docx"];
				previewController.filePathArray = @[path];
				[weakSelf.navigationController presentViewController:previewController animated:true completion:nil];
			}
		}];
		
		_checkBoxButton.selected = true;
		[weakSelf validateInputGuard];

	}
	return _checkBoxButton;
}


- (UIButton *)loginButton {
	if (!_loginButton) {
		_loginButton = [[UIButton alloc] initWithFrame:CGRectMake(self.checkBoxButton.ht_x, self.checkBoxButton.ht_y + self.checkBoxButton.ht_h + 20, self.checkBoxButton.ht_w, 20)];
		_loginButton.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleDetailLarge];
		[_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[_loginButton setTitle:@"已有账号? 立即登录" forState:UIControlStateNormal];
		__weak HTRegisterController *weakSelf = self;
		[_loginButton ht_whenTap:^(UIView *view) {
			[weakSelf.navigationController popViewControllerAnimated:true];
		}];
	}
	return _loginButton;
}

@end
