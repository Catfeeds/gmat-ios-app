//
//  HTLoginPushGroupView.m
//  GMat
//
//  Created by hublot on 2016/10/31.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTLoginPushGroupView.h"
#import "HTLoginManager.h"


@interface HTLoginPushGroupView ()

@property (nonatomic, strong) UIView *firstLineView;

@property (nonatomic, strong) UIView *secondLineView;

@end

@implementation HTLoginPushGroupView

- (void)dealloc {
	
}

- (void)didMoveToSuperview {
//	[self ht_addStackDistanceWithSubViews:@[self.handRisterButton, self.firstLineView, self.loginByQQButton, self.secondLineView, self.forgetPasswordButton] foreSpaceDistance:10 backSpaceDistance:10 stackDistanceDirection:HTStackDistanceDirectionHorizontal];
	[self ht_addStackDistanceWithSubViews:@[self.handRisterButton, self.firstLineView, self.forgetPasswordButton] foreSpaceDistance:10 backSpaceDistance:10 stackDistanceDirection:HTStackDistanceDirectionHorizontal];
}

- (UIButton *)forgetPasswordButton {
	if (!_forgetPasswordButton) {
		_forgetPasswordButton = [HTLoginPushGroupView normalButton];
		[_forgetPasswordButton setTitle:@"忘记密码" forState:UIControlStateNormal];		
	}
	return _forgetPasswordButton;
}

- (UIView *)firstLineView {
	if (!_firstLineView) {
		_firstLineView = [HTLoginPushGroupView normalLineView];
	}
	return _firstLineView;
}


- (UIButton *)handRisterButton {
	if (!_handRisterButton) {
		_handRisterButton = [HTLoginPushGroupView normalButton];
		[_handRisterButton setTitle:@"立即注册" forState:UIControlStateNormal];
	}
	return _handRisterButton;
}

- (UIView *)secondLineView {
	if (!_secondLineView) {
		_secondLineView = [HTLoginPushGroupView normalLineView];
	}
	return _secondLineView;
}


//- (UIButton *)loginByQQButton {
//	if (!_loginByQQButton) {
//		_loginByQQButton = [HTLoginPushGroupView normalButton];
//		[_loginByQQButton setTitle:@"QQ登录" forState:UIControlStateNormal];
//	}
//	return _loginByQQButton;
//}

+ (UIButton *)normalButton {
	UIButton *normalButton = [[UIButton alloc] init];
	[normalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	normalButton.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleDetailLarge];
	return normalButton;
}

+ (UIView *)normalLineView {
	UIView *normalLineView = [[UIView alloc] init];
	normalLineView.backgroundColor = [UIColor whiteColor];
	normalLineView.ht_w = 1;
	normalLineView.ht_h = 15;
	return normalLineView;
}

@end
