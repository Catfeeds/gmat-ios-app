//
//  HTPlayerView+HTView.m
//  GMat
//
//  Created by hublot on 2017/9/28.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTPlayerView+HTView.h"
#import "HTPlayerBrightnessView.h"

@implementation HTPlayerView (HTView)

- (void)didMoveToSuperview {
	[self addSubview:self.documentImageView];
	[self addSubview:self.playerView];
	[self addSubview:self.navigationBar];
	[self addSubview:self.playerTabBar];
	[self addSubview:self.playerLeftBar];
	[self addSubview:self.configureView];
	[self addSubview:self.playerSeekView];
	[self addSubview:self.toolBar];
	[HTPlayerBrightnessView brightnessLaunchSuperView:self];
	[self addSubview:self.loadIndicatorView];
	
	[self.documentImageView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
	[self.toolBar mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
	[self.navigationBar mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.left.right.mas_equalTo(self);
		make.height.mas_equalTo(MAX(20, [UIApplication sharedApplication].statusBarFrame.size.height) + 44);
	}];
	[self.playerLeftBar mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.navigationBar.mas_bottom);
		make.bottom.mas_equalTo(self.playerTabBar.mas_top);
		make.left.mas_equalTo(self);
		make.width.mas_equalTo(80);
	}];
	[self.playerTabBar mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.right.bottom.mas_equalTo(self);
		make.height.mas_equalTo(44);
	}];
	[self.loadIndicatorView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.center.mas_equalTo(self);
		make.width.height.mas_equalTo(100);
	}];
	[self.configureView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(200);
		make.left.mas_equalTo(self.mas_right);
		make.top.bottom.mas_equalTo(self);
	}];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect playerFrame = self.playerView.frame;
	CGFloat height = 100;
	CGFloat width = height * (4.0 / 3);
	playerFrame.size = CGSizeMake(width, height);
	self.playerView.frame = playerFrame;
}

- (void)aligmnDragViewRightBottom {
	CGRect playerViewFrame = self.playerView.frame;
	playerViewFrame.origin = CGPointMake(MAXFLOAT, MAXFLOAT);
	self.playerView.frame = playerViewFrame;
	[self reloadDragViewFrame];
}

- (void)reloadDragViewFrame {
	CGRect playerViewFrame = self.playerView.frame;
	playerViewFrame.origin.x = MAX(0, MIN(playerViewFrame.origin.x, self.bounds.size.width - playerViewFrame.size.width));
	playerViewFrame.origin.y = MAX(0, MIN(playerViewFrame.origin.y, self.bounds.size.height - playerViewFrame.size.height));
	self.playerView.frame = playerViewFrame;
}

@end
