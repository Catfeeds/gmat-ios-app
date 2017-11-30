//
//  HTCroppedHelperView.m
//  PhotoCutHelper
//
//  Created by hublot on 2017/6/2.
//  Copyright © 2017年 hublot. All rights reserved.
//

#import "HTCroppedHelperView.h"
#import "HTManagerController.h"
#import <UIButton+HTButtonCategory.h>

@interface HTCroppedHelperView ()

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UIImageView *croppedImageView;

@property (nonatomic, strong) UIButton *ignoreHelpButton;

@property (nonatomic, strong) UIButton *continueButton;

@end

static NSString *kHTCroppedHelperIgnoreKey = @"kHTCroppedHelperIgnoreKey";

@implementation HTCroppedHelperView

+ (void)showHelperView {
	if (![[NSUserDefaults standardUserDefaults] valueForKey:kHTCroppedHelperIgnoreKey]) {
		HTCroppedHelperView *croppedHelperView = [[HTCroppedHelperView alloc] init];
		croppedHelperView.tintColor = [UIColor ht_colorString:@"98cbff"];
		[croppedHelperView.backgroundView addSubview:croppedHelperView];
		[[HTManagerController defaultManagerController].view addSubview:croppedHelperView.backgroundView];
	}
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.transform = CGAffineTransformMakeRotation(M_PI_2);
}

- (void)dismissCroppedHelperView {
	[self.backgroundView removeFromSuperview];
}

- (void)didMoveToSuperview {
	CGSize screenSize = [UIScreen mainScreen].bounds.size;
	CGSize croppedSize = CGSizeMake(480, 280);
	CGRect croppedFrame = CGRectMake((screenSize.width - croppedSize.width) / 2, (screenSize.height - croppedSize.height) / 2, croppedSize.width, croppedSize.height);
	self.frame = croppedFrame;
	self.backgroundColor = self.tintColor;
	self.layer.cornerRadius = 5;
	self.layer.masksToBounds = true;
	[self addSubview:self.titleNameLabel];
	[self addSubview:self.croppedImageView];
	[self addSubview:self.ignoreHelpButton];
	[self addSubview:self.continueButton];
	[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(0);
		make.height.mas_equalTo(50);
		make.left.mas_equalTo(self);
		make.right.mas_equalTo(self);
	}];
	[self.croppedImageView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.titleNameLabel.mas_bottom).offset(0);
		make.centerX.mas_equalTo(self);
		make.width.mas_equalTo(self).offset(- 60);
	}];
	[self.ignoreHelpButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.croppedImageView);
		make.top.mas_equalTo(self.croppedImageView.mas_bottom);
		make.height.mas_equalTo(50);
	}];
	
	UIView *lineView = [[UIView alloc] init];
	lineView.backgroundColor = [UIColor whiteColor];
	[self addSubview:lineView];
	[lineView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.ignoreHelpButton.mas_bottom);
		make.left.mas_equalTo(self);
		make.right.mas_equalTo(self);
		make.bottom.mas_equalTo(self.continueButton.mas_top);
		make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
	}];
	
	[self.continueButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self);
		make.right.mas_equalTo(self);
		make.bottom.mas_equalTo(self);
		make.height.mas_equalTo(49);
	}];
}

- (UIView *)backgroundView {
	if (!_backgroundView) {
		_backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
		_backgroundView.backgroundColor = [UIColor blackColor];
		_backgroundView.userInteractionEnabled = true;
	}
	return _backgroundView;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.textColor = [UIColor whiteColor];
		_titleNameLabel.font = [UIFont systemFontOfSize:14];
		_titleNameLabel.textAlignment = NSTextAlignmentCenter;
		_titleNameLabel.text = @"请拖动裁剪框四周选择一道需要搜索的题目";
	}
	return _titleNameLabel;
}

- (UIImageView *)croppedImageView {
	if (!_croppedImageView) {
		_croppedImageView = [[UIImageView alloc] init];
		_croppedImageView.image = [UIImage imageNamed:@"ExerciseSearchCroppedTap"];
	}
	return _croppedImageView;
}

- (UIButton *)ignoreHelpButton {
	if (!_ignoreHelpButton) {
		_ignoreHelpButton = [[UIButton alloc] init];
		[_ignoreHelpButton setImage:[[UIImage imageNamed:@"ExerciseSearchCroppedNormal"] ht_resetSizeZoomNumber:0.6] forState:UIControlStateNormal];
		[_ignoreHelpButton setImage:[[UIImage imageNamed:@"ExerciseSearchCroppedNormal"] ht_resetSizeZoomNumber:0.6] forState:UIControlStateHighlighted];
		[_ignoreHelpButton setImage:[[UIImage imageNamed:@"ExerciseSearchCroppedSelected"] ht_resetSizeZoomNumber:0.6] forState:UIControlStateSelected];
		[_ignoreHelpButton setTitle:@"不再提示" forState:UIControlStateNormal];
		[_ignoreHelpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		_ignoreHelpButton.titleLabel.font = [UIFont systemFontOfSize:14];
		[_ignoreHelpButton ht_makeEdgeWithDirection:HTButtonEdgeDirectionHorizontal imageViewToTitleLabelSpeceOffset:3];
		
		__weak HTCroppedHelperView *weakSelf = self;
		[_ignoreHelpButton ht_whenTap:^(UIView *view) {
			weakSelf.ignoreHelpButton.selected = !weakSelf.ignoreHelpButton.selected;
		}];
	}
	return _ignoreHelpButton;
}

- (UIButton *)continueButton {
	if (!_continueButton) {
		_continueButton = [[UIButton alloc] init];
		_continueButton.titleLabel.font = [UIFont systemFontOfSize:15];
		[_continueButton setTitle:@"继续" forState:UIControlStateNormal];
		
		[_continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[_continueButton setBackgroundImage:[UIImage ht_pureColor:self.tintColor] forState:UIControlStateNormal];
		
		[_continueButton setTitleColor:self.tintColor forState:UIControlStateHighlighted];
		[_continueButton setBackgroundImage:[UIImage ht_pureColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
		
		__weak HTCroppedHelperView *weakSelf = self;
		[_continueButton ht_whenTap:^(UIView *view) {
			if (weakSelf.ignoreHelpButton.selected) {
				[[NSUserDefaults standardUserDefaults] setValue:kHTCroppedHelperIgnoreKey forKey:kHTCroppedHelperIgnoreKey];
			}
			[weakSelf dismissCroppedHelperView];
		}];
	}
	return _continueButton;
}

@end
