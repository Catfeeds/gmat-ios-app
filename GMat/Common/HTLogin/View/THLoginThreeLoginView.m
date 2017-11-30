//
//  THLoginThreeLoginView.m
//  TingApp
//
//  Created by hublot on 16/8/21.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "THLoginThreeLoginView.h"

@interface THLoginThreeLoginView ()

@property (nonatomic, strong) UIView *loginButtonContentView;

@property (nonatomic, strong) NSMutableArray <UIView *> *centerButtonArray;

@property (nonatomic, strong) UIView *leftLineView;

@property (nonatomic, strong) UIView *rightLineView;

@property (nonatomic, strong) UILabel *centerLabel;

@end

@implementation THLoginThreeLoginView

- (void)didMoveToSuperview {
	[self addSubview:self.leftLineView];
	[self addSubview:self.centerLabel];
	[self addSubview:self.rightLineView];
	[self addSubview:self.loginButtonContentView];
	[self.loginButtonContentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsMake(20, 0, 0, 0));
	}];
	[self.loginButtonContentView ht_addStackDistanceWithSubViews:self.centerButtonArray foreSpaceDistance:HTADAPT568(40) backSpaceDistance:HTADAPT568(40) stackDistanceDirection:HTStackDistanceDirectionHorizontal];
	[self.leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self).offset(20);
		make.right.mas_equalTo(self.centerLabel.mas_left).offset(- 10);
		make.centerY.mas_equalTo(self.centerLabel);
		make.height.mas_equalTo(1);
	}];
	[self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self);
	}];
	[self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.centerLabel.mas_right).offset(10);
		make.right.mas_equalTo(self).offset(- 20);
		make.height.mas_equalTo(1);
		make.width.mas_equalTo(self.leftLineView);
		make.centerY.mas_equalTo(self.centerLabel);
	}];
	
}

- (UIView *)leftLineView {
	if (!_leftLineView) {
		_leftLineView = [[UIView alloc] init];
		_leftLineView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.4];
	}
	return _leftLineView;
}

- (UIView *)rightLineView {
	if (!_rightLineView) {
		_rightLineView = [[UIView alloc] init];
		_rightLineView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.4];
	}
	return _rightLineView;
}

- (UILabel *)centerLabel {
	if (!_centerLabel) {
		_centerLabel = [[UILabel alloc] init];
		_centerLabel.text = @"使用社交账号登录";
		_centerLabel.textColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
		_centerLabel.font = [UIFont ht_fontStyle:HTFontStyleDetailSmall];
	}
	return _centerLabel;
}

- (UIView *)loginButtonContentView {
	if (!_loginButtonContentView) {
		_loginButtonContentView = [[UIView alloc] init];
	}
	return _loginButtonContentView;
}

- (NSMutableArray <UIView *> *)centerButtonArray {
	if (!_centerButtonArray) {
		_centerButtonArray = [@[] mutableCopy];
		NSArray *imageArray = @[@"ToeflQQ", @"Toeflweixin", @"Toeflweibo"];
		for (NSInteger index = 0; index < 3; index ++) {
			UIButton *loginButton = [[UIButton alloc] init];
			[loginButton setImage:[UIImage imageNamed:imageArray[index]] forState:UIControlStateNormal];
			[loginButton ht_whenTap:^(UIView *view) {
				
			}];
			[self.centerButtonArray addObject:loginButton];
		}
	}
	return _centerButtonArray;
}

@end
