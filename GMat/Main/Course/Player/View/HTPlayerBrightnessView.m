//
//  HTPlayerBrightnessView.m
//  GMat
//
//  Created by hublot on 2017/9/29.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTPlayerBrightnessView.h"

@interface HTPlayerBrightnessView ()

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UIImageView *lightImageView;

@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (nonatomic, assign) BOOL willHiddenBrightness;

@property (nonatomic, assign) BOOL willHiddenAnimated;

@end

@implementation HTPlayerBrightnessView

- (BOOL)willDealloc {
	return false;
}

static HTPlayerBrightnessView *brightnessView;

+ (instancetype)defaultBrightnessView {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		brightnessView = [[HTPlayerBrightnessView alloc] init];
	});
	return brightnessView;
}

+ (void)brightnessLaunchSuperView:(UIView *)superView {
	[superView addSubview:[HTPlayerBrightnessView defaultBrightnessView]];
	[brightnessView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.center.mas_equalTo(superView);
		make.width.height.mas_equalTo(155);
	}];
}

- (void)didMoveToSuperview {
	self.userInteractionEnabled = false;
	self.layer.cornerRadius = 10;
	self.layer.masksToBounds = true;
	[self addSubview:self.titleNameLabel];
	[self addSubview:self.lightImageView];
	[self.layer addSublayer:self.progressLayer];
	[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.right.mas_equalTo(self);
		make.top.mas_equalTo(5);
		make.height.mas_equalTo(30);
	}];
	[self.lightImageView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(85);
		make.center.mas_equalTo(self);
	}];
	self.willHiddenBrightness = true;
	self.willHiddenAnimated = false;
	[self switchBrightnessViewHidden];
	[[UIScreen mainScreen] bk_addObserverForKeyPath:NSStringFromSelector(@selector(brightness)) options:NSKeyValueObservingOptionNew task:^(id obj, NSDictionary *change) {
		[CATransaction begin];
		[CATransaction setDisableActions:true];
		self.progressLayer.strokeEnd = [UIScreen mainScreen].brightness;
		[CATransaction commit];
		self.willHiddenBrightness = false;
		self.willHiddenAnimated = true;
		[self switchBrightnessViewHidden];
	}];
}

- (void)switchBrightnessViewHidden {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchBrightnessViewHidden) object:nil];
	[UIView animateWithDuration:self.willHiddenAnimated ? 0.15 : 0 animations:^{
		if (self.willHiddenBrightness) {
			self.alpha = 0;
		} else {
			self.alpha = 1;
		}
	} completion:^(BOOL finished) {
		if (!self.willHiddenBrightness) {
			self.willHiddenBrightness = true;
			self.willHiddenAnimated = true;
			[self performSelector:@selector(switchBrightnessViewHidden) withObject:nil afterDelay:1];
		}
	}];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.progressLayer.bounds = CGRectMake(0, 0, self.bounds.size.width - 30, 7);
	self.progressLayer.lineWidth = self.progressLayer.bounds.size.height;
	self.progressLayer.position = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height - 20);
	UIBezierPath *bezierPath = [UIBezierPath bezierPath];
	[bezierPath moveToPoint:CGPointMake(0, self.progressLayer.bounds.size.height / 2)];
	[bezierPath addLineToPoint:CGPointMake(self.progressLayer.bounds.size.width, self.progressLayer.bounds.size.height / 2)];
	self.progressLayer.path = bezierPath.CGPath;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.font  = [UIFont boldSystemFontOfSize:16];
		_titleNameLabel.textColor = [UIColor colorWithRed:0.25f green:0.22f blue:0.21f alpha:1.00f];
		_titleNameLabel.textAlignment = NSTextAlignmentCenter;
		_titleNameLabel.text = @"亮度";
	}
	return _titleNameLabel;
}

- (UIImageView *)lightImageView {
	if (!_lightImageView) {
		_lightImageView = [[UIImageView alloc] init];
		UIImage *image = [UIImage imageNamed:@"cn_player_light"];
		_lightImageView.image = image;
	}
	return _lightImageView;
}

- (CAShapeLayer *)progressLayer {
	if (!_progressLayer) {
		_progressLayer = [CAShapeLayer layer];
		_progressLayer.backgroundColor = [UIColor blackColor].CGColor;
		_progressLayer.borderColor = _progressLayer.backgroundColor;
		_progressLayer.borderWidth = 1;
		_progressLayer.strokeColor = [UIColor whiteColor].CGColor;
		_progressLayer.lineCap = kCALineCapButt;
		_progressLayer.lineJoin = kCALineJoinMiter;
		_progressLayer.lineDashPattern = @[@(6.82), @(1)];
	}
	return _progressLayer;
}

@end
