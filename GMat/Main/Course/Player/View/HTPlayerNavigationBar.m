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

@end

@implementation HTPlayerNavigationBar

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
	[self addSubview:self.barView];
	[self.barView addSubview:self.backItemButton];
	
	[self.barView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.bottom.left.right.mas_equalTo(self);
		make.top.mas_equalTo([UIApplication sharedApplication].statusBarFrame.size.height);
	}];
	[self.backItemButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.centerY.mas_equalTo(self.barView);
		make.left.mas_equalTo(15);
	}];
}

- (void)setIsPortrait:(BOOL)isPortrait {
	[self didMoveToSuperview];
	__weak typeof(self) weakSelf = self;
	if (isPortrait) {
		self.backItemButton.backgroundColor = self.backgroundColor;
		[self.backItemButton ht_whenTap:^(UIView *view) {
			[weakSelf.ht_controller.navigationController popViewControllerAnimated:true];
		}];
	} else {
		self.backItemButton.backgroundColor = [UIColor clearColor];
		[self.backItemButton ht_whenTap:^(UIView *view) {
			[HTManagerController setDeviceOrientation:UIDeviceOrientationPortrait];
		}];
	}
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.backItemButton.layer.cornerRadius = self.backItemButton.bounds.size.height / 2;
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
		image = [image ht_resetSizeZoomNumber:0.8];
		image = [image ht_tintColor:[UIColor whiteColor]];
		[_backItemButton setImage:image forState:UIControlStateNormal];
		_backItemButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
		_backItemButton.layer.masksToBounds = true;
	}
	return _backItemButton;
}

@end
