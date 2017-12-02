//
//  THHamburgerButton.m
//  测试汉堡按钮
//
//  Created by hublot on 2016/10/19.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "THHamburgerButton.h"

@interface THHamburgerButton ()

#define HamburgerButtonCenterLineStart 0.028

#define HamburgerButtonCenterLineEnd 0.111

#define HamburgerButtonCenterRadiusStart 0.325

#define HamburgerButtonCenterRadiusEnd 0.9

@property (nonatomic, strong) CAShapeLayer *topLayer;

@property (nonatomic, strong) CAShapeLayer *centerLayer;

@property (nonatomic, strong) CAShapeLayer *bottomLayer;

@end

@implementation THHamburgerButton

- (void)didMoveToSuperview {
	[self.layer addSublayer:self.topLayer];
	[self.layer addSublayer:self.centerLayer];
	[self.layer addSublayer:self.bottomLayer];
}

- (CAShapeLayer *)topLayer {
	if (!_topLayer) {
		_topLayer = [self customShapeLayerWithPath:[self initalizeTopOrBottomPath]];
		_topLayer.anchorPoint = CGPointMake(28.0 / 30, 0.5);
		_topLayer.position = CGPointMake(40, 18);
	}
	return _topLayer;
}

- (CAShapeLayer *)centerLayer {
	if (!_centerLayer) {
		UIBezierPath *bezierPath = [UIBezierPath bezierPath];
		[bezierPath moveToPoint:CGPointMake(10, 27)];
		[bezierPath addCurveToPoint:CGPointMake(40, 27) controlPoint1:CGPointMake(12, 27) controlPoint2:CGPointMake(28.02, 27)];
		[bezierPath addCurveToPoint:CGPointMake(27, 02) controlPoint1:CGPointMake(55.92, 27) controlPoint2:CGPointMake(50.47, 2)];
		[bezierPath addCurveToPoint:CGPointMake(2, 27) controlPoint1:CGPointMake(13.16, 2) controlPoint2:CGPointMake(2, 13.16)];
		[bezierPath addCurveToPoint:CGPointMake(27, 52) controlPoint1:CGPointMake(2, 40.84) controlPoint2:CGPointMake(13.16, 52)];
		[bezierPath addCurveToPoint:CGPointMake(52, 27) controlPoint1:CGPointMake(40.84, 52) controlPoint2:CGPointMake(52, 40.84)];
		[bezierPath addCurveToPoint:CGPointMake(27, 2) controlPoint1:CGPointMake(52, 13.16) controlPoint2:CGPointMake(42.39, 2)];
		[bezierPath addCurveToPoint:CGPointMake(2, 27) controlPoint1:CGPointMake(13.16, 2) controlPoint2:CGPointMake(2, 13.16)];

		_centerLayer = [self customShapeLayerWithPath:bezierPath.CGPath];
		_centerLayer.position = CGPointMake(27, 27);
		_centerLayer.strokeStart = HamburgerButtonCenterLineStart;
		_centerLayer.strokeEnd = HamburgerButtonCenterLineEnd;
	}
	return _centerLayer;
}

- (CAShapeLayer *)bottomLayer {
	if (!_bottomLayer) {
		_bottomLayer = [self customShapeLayerWithPath:[self initalizeTopOrBottomPath]];
		_bottomLayer.anchorPoint = CGPointMake(28.0 / 30, 0.5);
		_bottomLayer.position = CGPointMake(40, 36);
	}
	return _bottomLayer;
}

- (void)setShowMenu:(BOOL)showMenu {
	_showMenu = showMenu;
	
	CABasicAnimation *centerStrokeStart = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
	CABasicAnimation *centerStrokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
	
	CABasicAnimation *topTransform = [CABasicAnimation animationWithKeyPath:@"transform"];
	topTransform.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.5 :- 0.8 :0.5 :1.85];
	topTransform.duration = 0.4;
	topTransform.fillMode = kCAFillModeBackwards;
	CABasicAnimation *bottomTransform = topTransform.copy;
	if (self.showMenu) {
		centerStrokeStart.toValue = @(HamburgerButtonCenterRadiusStart);
		centerStrokeStart.duration = 0.5;
		centerStrokeStart.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25 :- 0.4 :0.5 :1];
		
		centerStrokeEnd.toValue = @(HamburgerButtonCenterRadiusEnd);
		centerStrokeEnd.duration = 0.6;
		centerStrokeEnd.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25 :- 0.4 :0.5 :1];
		
		
		CATransform3D translation = CATransform3DMakeTranslation(- 4, 0, 0);
		topTransform.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(translation, - 0.7853975, 0, 0, 1)];
		topTransform.beginTime = CACurrentMediaTime() + 0.25;
		bottomTransform.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(translation, 0.7853975, 0, 0, 1)];
		bottomTransform.beginTime = CACurrentMediaTime() + 0.25;
	} else {
		centerStrokeStart.toValue = @(HamburgerButtonCenterLineStart);
		centerStrokeStart.duration = 0.5;
		centerStrokeStart.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25 :0 :0.5 :1.2];
		centerStrokeStart.beginTime = CACurrentMediaTime() + 0.1;
		centerStrokeStart.fillMode = kCAFillModeBackwards;
		
		centerStrokeEnd.toValue = @(HamburgerButtonCenterLineEnd);
		centerStrokeEnd.duration = 0.6;
		centerStrokeEnd.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25 :0.3 :0.5 :0.9];
		
		topTransform.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
		topTransform.beginTime = CACurrentMediaTime() + 0.05;
		bottomTransform.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
		bottomTransform.beginTime = CACurrentMediaTime() + 0.05;
	}
	[self addAnimation:centerStrokeStart onLayer:self.centerLayer];
	[self addAnimation:centerStrokeEnd onLayer:self.centerLayer];
	[self addAnimation:topTransform onLayer:self.topLayer];
	[self addAnimation:bottomTransform onLayer:self.bottomLayer];
}

- (void)setProgress:(CGFloat)progress {
	if (_progress != progress) {
		_progress = MIN(MAX(0, progress), 1);
		self.centerLayer.strokeStart = HamburgerButtonCenterLineStart + (HamburgerButtonCenterRadiusStart - HamburgerButtonCenterLineStart) * _progress;
		self.centerLayer.strokeEnd = HamburgerButtonCenterLineEnd + (HamburgerButtonCenterRadiusEnd - HamburgerButtonCenterLineEnd) * _progress;
		CATransform3D translation = CATransform3DMakeTranslation(- 4 * _progress, 0, 0);
		self.topLayer.transform = CATransform3DRotate(translation, - 0.7853975 * _progress, 0, 0, 1);
		self.bottomLayer.transform = CATransform3DRotate(translation, 0.7853975 * _progress, 0, 0, 1);
	}
}

- (CAShapeLayer *)customShapeLayerWithPath:(CGPathRef)path {
	CAShapeLayer *shapeLayer = [CAShapeLayer layer];
	shapeLayer.path = path;
	shapeLayer.fillColor = nil;
	shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
	shapeLayer.lineWidth = 4;
	shapeLayer.miterLimit = 4;
	shapeLayer.lineCap = kCALineCapRound;
	shapeLayer.masksToBounds = true;
	shapeLayer.actions = @{
						   @"strokeStart": [NSNull null],
						   @"strokeEnd": [NSNull null],
						   @"transform": [NSNull null]
						   };
	CGPathRef pathRef = CGPathCreateCopyByStrokingPath(shapeLayer.path, nil, 4, kCGLineCapRound, kCGLineJoinMiter, 4);
	shapeLayer.bounds = CGPathGetBoundingBox(pathRef);
	CGPathRelease(pathRef);
	return shapeLayer;
}

- (CGPathRef)initalizeTopOrBottomPath {
	UIBezierPath *bezierPath = [UIBezierPath bezierPath];
	[bezierPath moveToPoint:CGPointMake(2, 2)];
	[bezierPath addLineToPoint:CGPointMake(28, 2)];
	return bezierPath.CGPath;
}

- (void)addAnimation:(CAAnimation *)baseAnimation onLayer:(CALayer *)layer {
	CABasicAnimation *animation = [baseAnimation copy];
	if (!animation.fromValue) {
		animation.fromValue = [layer.presentationLayer valueForKeyPath:animation.keyPath];
	}
	[layer addAnimation:animation forKey:animation.keyPath];
	[layer setValue:animation.toValue forKeyPath:animation.keyPath];
}

@end
