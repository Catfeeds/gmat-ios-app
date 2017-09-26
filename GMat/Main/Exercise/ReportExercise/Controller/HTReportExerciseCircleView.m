//
//  HTReportExerciseCircleView.m
//  GMat
//
//  Created by hublot on 16/11/30.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTReportExerciseCircleView.h"

@interface HTReportExerciseCircleView ()

@property (nonatomic, strong) CAShapeLayer *contentShapeLayer;

@property (nonatomic, strong) CAShapeLayer *progressShapeLayer;

@property (nonatomic, strong) UILabel *detailNameLabel;

@end

@implementation HTReportExerciseCircleView

- (void)didMoveToSuperview {
	[self.layer addSublayer:self.contentShapeLayer];
	[self.layer addSublayer:self.progressShapeLayer];
	[self addSubview:self.detailNameLabel];
	[self.detailNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.left.right.mas_equalTo(self);
		make.height.mas_equalTo(50);
	}];
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.bottomDetailName = @"正确率(20%)";
		self.progress = 1 / 5.0;
		self.tintColor = [UIColor ht_colorStyle:HTColorStylePrimaryTheme];
	}
	return self;
}

- (void)setBottomDetailName:(NSString *)bottomDetailName {
	_bottomDetailName = bottomDetailName;
	self.detailNameLabel.text = bottomDetailName;
}

- (void)setProgress:(CGFloat)progress {
	_progress = progress;
	UIBezierPath *bezierPath = [UIBezierPath bezierPath];
	[bezierPath moveToPoint:CGPointMake(self.ht_w / 2, self.ht_h / 2 - 10)];
	[bezierPath addArcWithCenter:CGPointMake(self.ht_w / 2, self.ht_h / 2 - 10) radius:50 startAngle:- M_PI_2 endAngle:M_PI * 2 * progress - M_PI_2 clockwise:true];
	[bezierPath closePath];
	self.progressShapeLayer.path = bezierPath.CGPath;
}

- (void)setTintColor:(UIColor *)tintColor {
	_tintColor = tintColor;
	self.contentShapeLayer.strokeColor = tintColor.CGColor;
	self.progressShapeLayer.fillColor = tintColor.CGColor;
}

- (CAShapeLayer *)contentShapeLayer {
	if (!_contentShapeLayer) {
		_contentShapeLayer = [CAShapeLayer layer];
		UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.ht_w / 2, self.ht_h / 2 - 10) radius:50 startAngle:- M_PI_2 endAngle:M_PI * 2 - M_PI_2 clockwise:true];
		_contentShapeLayer.path = bezierPath.CGPath;
		_contentShapeLayer.fillColor = [UIColor whiteColor].CGColor;
	}
	return _contentShapeLayer;
}

- (CAShapeLayer *)progressShapeLayer {
	if (!_progressShapeLayer) {
		_progressShapeLayer = [CAShapeLayer layer];
		_progressShapeLayer.strokeColor = [UIColor clearColor].CGColor;
	}
	return _progressShapeLayer;
}


- (UILabel *)detailNameLabel {
	if (!_detailNameLabel) {
		_detailNameLabel = [[UILabel alloc] init];
		_detailNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_detailNameLabel.font = [UIFont systemFontOfSize:14];
		_detailNameLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _detailNameLabel;
}

@end
