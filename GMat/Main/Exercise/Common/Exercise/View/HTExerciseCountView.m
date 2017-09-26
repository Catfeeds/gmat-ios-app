//
//  HTExerciseCountView.m
//  GMat
//
//  Created by hublot on 2017/5/17.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTExerciseCountView.h"

@interface HTExerciseCountView ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIView *darkMaskView;

@property (nonatomic, strong) UIButton *centerCountButton;

@property (nonatomic, strong) UIButton *topCountButton;

@property (nonatomic, strong) UIButton *bottomCountButton;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (nonatomic, strong) UIVisualEffectView *blurErrectView;

@end

@implementation HTExerciseCountView

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	CGRect centerCountButtonFrame = self.centerCountButton.frame;
	CGRect topCountButtonFrame = self.topCountButton.frame;
	CGRect bottomCountButtonFrame = self.bottomCountButton.frame;
	UIBezierPath *bezierPath = [UIBezierPath bezierPath];
	UIBezierPath *leftBezierPath = [UIBezierPath bezierPath];
	UIBezierPath *rightBezierPath = [UIBezierPath bezierPath];
	NSArray *pointValueArray = @[
								 [NSValue valueWithCGPoint:CGPointMake(topCountButtonFrame.origin.x, self.topCountButton.center.y)],
								 [NSValue valueWithCGPoint:CGPointMake(centerCountButtonFrame.origin.x, self.topCountButton.center.y)],
								 [NSValue valueWithCGPoint:CGPointMake(centerCountButtonFrame.origin.x, self.bottomCountButton.center.y)],
								 [NSValue valueWithCGPoint:CGPointMake(bottomCountButtonFrame.origin.x, self.bottomCountButton.center.y)],
								 ];
	[pointValueArray enumerateObjectsUsingBlock:^(NSValue *pointValue, NSUInteger index, BOOL * _Nonnull stop) {
		CGPoint leftPoint = pointValue.CGPointValue;
		CGPoint rightPoint = CGPointMake((self.bounds.size.width / 2 - leftPoint.x) * 2 + leftPoint.x, leftPoint.y);
		if (index == 0) {
			[leftBezierPath moveToPoint:leftPoint];
			[rightBezierPath moveToPoint:rightPoint];
		} else {
			[leftBezierPath addLineToPoint:leftPoint];
			[rightBezierPath addLineToPoint:rightPoint];
		}
	}];
	[leftBezierPath appendPath:rightBezierPath];
	bezierPath = leftBezierPath;
	self.shapeLayer.frame = self.darkMaskView.bounds;
	self.shapeLayer.path = bezierPath.CGPath;
}

- (void)setBlurProgress:(CGFloat)blurProgress {
	self.blurErrectView.alpha = blurProgress;
}

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor clearColor];
	[self addSubview:self.backgroundImageView];
	[self addSubview:self.darkMaskView];
	[self.darkMaskView addSubview:self.centerCountButton];
	[self.darkMaskView addSubview:self.topCountButton];
	[self.darkMaskView addSubview:self.bottomCountButton];
	[self.darkMaskView.layer addSublayer:self.shapeLayer];
	[self addSubview:self.blurErrectView];
	
	[self.backgroundImageView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(self);
	}];
	[self.darkMaskView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(self.backgroundImageView);
	}];
	[self.centerCountButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.center.mas_equalTo(self.darkMaskView);
	}];
	
	CGFloat bottomVerticalEdge = 5;
	[self.topCountButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.centerX.mas_equalTo(self.centerCountButton);
		make.bottom.mas_equalTo(self.centerCountButton.mas_top).offset(- bottomVerticalEdge);
	}];
	[self.bottomCountButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.centerCountButton.mas_bottom).offset(bottomVerticalEdge);
		make.centerX.mas_equalTo(self.centerCountButton);
	}];
	
	[self.blurErrectView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(self);
	}];
	
	self.centerCountButton.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
	self.topCountButton.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
	self.bottomCountButton.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
	
}

- (void)setModel:(HTExerciseQuestionCountModel *)model row:(NSInteger)row {
	NSDictionary *whiteAttribueDictionary = @{NSFontAttributeName:[UIFont systemFontOfSize:18],
											  NSForegroundColorAttributeName:[UIColor whiteColor]};
	NSDictionary *originAttributedDictionary = @{NSFontAttributeName:[UIFont systemFontOfSize:18],
											  NSForegroundColorAttributeName:[UIColor orangeColor]};
	NSAttributedString *appendAttribudString;

	NSAttributedString *topAttributedString = [[NSAttributedString alloc] initWithString:@"海量题目、全面题型" attributes:whiteAttribueDictionary];
	
	NSMutableAttributedString *centerAttributedString = [[[NSAttributedString alloc] initWithString:@"已有 Verbal " attributes:whiteAttribueDictionary] mutableCopy];
	appendAttribudString = [[NSAttributedString alloc] initWithString:model.verbalNum attributes:originAttributedDictionary];
	[centerAttributedString appendAttributedString:appendAttribudString];
	appendAttribudString = [[NSAttributedString alloc] initWithString:@"题、 Quant" attributes:whiteAttribueDictionary];
	[centerAttributedString appendAttributedString:appendAttribudString];
	appendAttribudString = [[NSAttributedString alloc] initWithString:model.quantNum attributes:originAttributedDictionary];
	[centerAttributedString appendAttributedString:appendAttribudString];
	appendAttribudString = [[NSAttributedString alloc] initWithString:@"题" attributes:whiteAttribueDictionary];
	[centerAttributedString appendAttributedString:appendAttribudString];
	
	NSMutableAttributedString *bottomAttributedString = [[[NSAttributedString alloc] initWithString:model.viewCount attributes:originAttributedDictionary] mutableCopy];
	appendAttribudString = [[NSAttributedString alloc] initWithString:@"人在雷哥网备考" attributes:whiteAttribueDictionary];
	[bottomAttributedString appendAttributedString:appendAttribudString];
	
	[self.topCountButton setAttributedTitle:topAttributedString forState:UIControlStateNormal];
	[self.centerCountButton setAttributedTitle:centerAttributedString forState:UIControlStateNormal];
	[self.bottomCountButton setAttributedTitle:bottomAttributedString forState:UIControlStateNormal];
	
	[self setNeedsLayout];
	[self setNeedsDisplay];
}

- (UIImageView *)backgroundImageView {
	if (!_backgroundImageView) {
		_backgroundImageView = [[UIImageView alloc] init];
		_backgroundImageView.image = [UIImage imageNamed:@"ExerciseIndexHeader"];
		_backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
		_backgroundImageView.clipsToBounds = true;
	}
	return _backgroundImageView;
}

- (UIView *)darkMaskView {
	if (!_darkMaskView) {
		_darkMaskView = [[UIView alloc] init];
		_darkMaskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
	}
	return _darkMaskView;
}

- (UIButton *)centerCountButton {
	if (!_centerCountButton) {
		_centerCountButton = [[UIButton alloc] init];
	}
	return _centerCountButton;
}

- (UIButton *)topCountButton {
	if (!_topCountButton) {
		_topCountButton = [[UIButton alloc] init];
	}
	return _topCountButton;
}

- (UIButton *)bottomCountButton {
	if (!_bottomCountButton) {
		_bottomCountButton = [[UIButton alloc] init];
	}
	return _bottomCountButton;
}

- (CAShapeLayer *)shapeLayer {
	if (!_shapeLayer) {
		_shapeLayer = [CAShapeLayer layer];
		_shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
		_shapeLayer.fillColor = [UIColor clearColor].CGColor;
		_shapeLayer.lineWidth = 1 / [UIScreen mainScreen].scale;
	}
	return _shapeLayer;
}

- (UIVisualEffectView *)blurErrectView {
	if (!_blurErrectView) {
		_blurErrectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
	}
	return _blurErrectView;
}

@end
