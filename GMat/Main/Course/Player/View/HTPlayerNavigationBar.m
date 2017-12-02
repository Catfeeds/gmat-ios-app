//
//  HTPlayerNavigationBar.m
//  GMat
//
//  Created by hublot on 2017/9/26.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTPlayerNavigationBar.h"
#import "HTManagerController+HTRotate.h"

@interface HTPlayerNavigationBar ()

@property (nonatomic, strong) UIView *barView;

@property (nonatomic, strong) UIButton *backItemButton;

@property (nonatomic, strong) UILabel *titleNameLabel;

@end

@implementation HTPlayerNavigationBar

- (void)dealloc {
	
}

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
	[self addSubview:self.barView];
	[self addSubview:self.backItemButton];
	[self addSubview:self.titleNameLabel];
	[self.barView addSubview:self.speedButton];
	[self.barView addSubview:self.teacherButton];
	
	[self.barView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.bottom.left.right.mas_equalTo(self);
		make.top.mas_equalTo([UIApplication sharedApplication].statusBarFrame.size.height);
	}];
	[self.backItemButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.centerY.mas_equalTo(self.barView);
		make.left.mas_equalTo(15);
	}];
	[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.centerY.mas_equalTo(self.barView);
		make.height.mas_equalTo(self.barView);
		make.left.mas_equalTo(self.backItemButton.mas_right).offset(15);
		make.right.mas_lessThanOrEqualTo(self.speedButton.mas_left).offset(- 15);
	}];
	[self.teacherButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.centerY.mas_equalTo(self.barView);
		make.right.mas_equalTo(self.speedButton.mas_left).offset(- 15);
	}];
	[self.speedButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.centerY.mas_equalTo(self.barView);
		make.right.mas_equalTo(- 15);
	}];
}

- (void)setPlayerModel:(HTPlayerModel *)playerModel {
	_playerModel = playerModel;
	self.titleNameLabel.text = playerModel.titleName;
}

- (UIView *)barView {
	if (!_barView) {
		_barView = [[UIView alloc] init];
	}
	return _barView;
}

- (UIButton *)backItemButton {
	if (!_backItemButton) {
		_backItemButton = [[UIButton alloc] init];
		UIImage *image = [UIImage imageNamed:@"Back"];
		image = [image ht_tintColor:[UIColor whiteColor]];
		[_backItemButton setImage:image forState:UIControlStateNormal];
		_backItemButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
		[_backItemButton ht_whenTap:^(UIView *view) {
			[HTManagerController setDeviceOrientation:UIDeviceOrientationPortrait];
		}];
	}
	return _backItemButton;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.font = [UIFont systemFontOfSize:16];
		_titleNameLabel.textColor = [UIColor whiteColor];
		[_titleNameLabel setContentHuggingPriority:100 forAxis:UILayoutConstraintAxisHorizontal];
		[_titleNameLabel setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisHorizontal];
	}
	return _titleNameLabel;
}

- (UIButton *)speedButton {
	if (!_speedButton) {
		_speedButton = [[UIButton alloc] init];
		_speedButton.titleLabel.font = [UIFont systemFontOfSize:15];
		[_speedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		_speedButton.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
		_speedButton.layer.borderColor = [UIColor whiteColor].CGColor;
		_speedButton.contentEdgeInsets = UIEdgeInsetsMake(5, 15, 5, 15);
		[_speedButton setTitle:@"速度" forState:UIControlStateNormal];
		_speedButton.layer.cornerRadius = 3;
		_speedButton.layer.masksToBounds = true;
	}
	return _speedButton;
}

- (UIButton *)teacherButton {
	if (!_teacherButton) {
		_teacherButton = [[UIButton alloc] init];
		
//		CGFloat scale = 0.19;
//		UIImage *normalImage = [UIImage imageNamed:@"cn_player_teacher_normal"];
//		normalImage = [normalImage ht_resetSizeZoomNumber:scale];
//		UIImage *selectedImage = [UIImage imageNamed:@"cn_player_teacher_hidden"];
//		selectedImage = [selectedImage ht_resetSizeZoomNumber:scale];
//		[_teacherButton setImage:normalImage forState:UIControlStateNormal];
//		[_teacherButton setImage:normalImage forState:UIControlStateNormal | UIControlStateHighlighted];
//		[_teacherButton setImage:selectedImage forState:UIControlStateSelected];
//		[_teacherButton setImage:selectedImage forState:UIControlStateSelected | UIControlStateHighlighted];
		
		_teacherButton.titleLabel.numberOfLines = 0;
		_teacherButton.titleLabel.font = [UIFont systemFontOfSize:12];
		[_teacherButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		NSString *normalTitle = @"关闭\n视频";
		NSString *selectedTitle = @"打开\n视频";
		[_teacherButton setTitle:normalTitle forState:UIControlStateNormal];
		[_teacherButton setTitle:normalTitle forState:UIControlStateNormal | UIControlStateHighlighted];
		[_teacherButton setTitle:selectedTitle forState:UIControlStateSelected];
		[_teacherButton setTitle:selectedTitle forState:UIControlStateSelected | UIControlStateHighlighted];
		_teacherButton.contentEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
	}
	return _teacherButton;
}

@end
