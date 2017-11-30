//
//  HTMineScrollView.m
//  GMat
//
//  Created by hublot on 16/11/13.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTMineScrollView.h"

@interface HTMineScrollView ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation HTMineScrollView

- (void)didMoveToSuperview {
	self.layer.masksToBounds = true;
	[self.layer addSublayer:self.shapeLayer];
}

- (void)setPullBlueRect:(CGRect)pullBlueRect {
	_pullBlueRect = pullBlueRect;
	UIBezierPath *bezierPath = [UIBezierPath bezierPath];
	[bezierPath moveToPoint:CGPointMake(0, pullBlueRect.origin.y)];
	[bezierPath addQuadCurveToPoint:CGPointMake(pullBlueRect.origin.x, pullBlueRect.origin.y) controlPoint:CGPointMake(pullBlueRect.size.width, pullBlueRect.size.height)];
	[bezierPath moveToPoint:CGPointMake(pullBlueRect.origin.x, pullBlueRect.origin.y)];
	[bezierPath addLineToPoint:CGPointMake(pullBlueRect.origin.x, 0)];
	[bezierPath addLineToPoint:CGPointMake(0, 0)];
	[bezierPath addLineToPoint:CGPointMake(0, pullBlueRect.origin.y)];
	[bezierPath closePath];
	self.shapeLayer.path = bezierPath.CGPath;
}

- (CAShapeLayer *)shapeLayer {
	if (!_shapeLayer) {
		_shapeLayer = [CAShapeLayer layer];
		_shapeLayer.fillColor = [UIColor ht_colorStyle:HTColorStylePrimaryTheme].CGColor;
	}
	return _shapeLayer;
}

@end
