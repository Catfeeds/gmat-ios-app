//
//  HTLoginTextFieldGroupView.h
//  GMat
//
//  Created by hublot on 2016/10/27.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HTLoginTextFieldGroupType) {
	HTLoginTextFieldGroupTypeRegister,
	HTLoginTextFieldGroupTypeForgetPassword,
	HTLoginTextFieldGroupTypeChangeUser
};

@interface HTLoginTextFieldGroupView : NSObject

@property (nonatomic, assign) HTLoginTextFieldGroupType textFieldGroupType;

@property (nonatomic, strong) UITextField *usernameTextField;

@property (nonatomic, strong) UITextField *passwordTextField;

@property (nonatomic, strong) UITextField *surePasswordTextField;

@property (nonatomic, strong) UITextField *phoneEmailTextField;

@property (nonatomic, strong) UITextField *messageCodeTextFiled;

@property (nonatomic, strong) UIButton *messageCodeButton;

- (void)resignFirstResponder;

@end
