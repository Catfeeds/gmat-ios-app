//
//  HTScanfView.m
//  画个框框
//
//  Created by hublot on 2017/3/23.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTScanfView.h"

typedef NS_ENUM(NSInteger, HTScanfDragStyle) {
	HTScanfDragStyleCenterNone,
	HTScanfDragStyleCenter,
	HTScanfDragStyleTop,
	HTScanfDragStyleLeft,
	HTScanfDragStyleBottom,
	HTScanfDragStyleRight,
	HTScanfDragStyleTopLeft,
	HTScanfDragStyleLeftBottom,
	HTScanfDragStyleBottomRight,
	HTScanfDragStyleRightTop
};

@interface HTScanfView ()

@property (nonatomic, strong) CAShapeLayer *scanfMaskLayer;

@property (nonatomic, assign) HTScanfDragStyle dragStyle;

@property (nonatomic, assign) CGPoint beginPoint;

@end

@implementation HTScanfView

- (instancetype)init {
	if (self = [super init]) {
		self.dragAble = true;
		self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
	}
	return self;
}

- (void)didMoveToSuperview {
	self.layer.mask = self.scanfMaskLayer;
}

- (void)drawRect:(CGRect)rect {
	
	CGFloat angleLineWidth = 2;
	CGFloat angleLineLength = 10;
	UIColor *angleLineColor = [UIColor blueColor];

	CGFloat borderLineWidth = 1;
	UIColor *borderLineColor = [UIColor blueColor];
	
	
	CGRect borderOutRect = CGRectInset(self.scanfRect, angleLineWidth, angleLineWidth);
	CGRect borderInRect = CGRectInset(borderOutRect, borderLineWidth, borderLineWidth);
	CGRect angleOutRect = self.scanfRect;
	
	UIBezierPath *angleOutBezierPath = [UIBezierPath bezierPathWithRect:angleOutRect];
	angleOutBezierPath.usesEvenOddFillRule = true;
	UIBezierPath *borderOutBezierPath = [UIBezierPath bezierPathWithRect:borderOutRect];
	borderOutBezierPath.usesEvenOddFillRule = true;
	UIBezierPath *borderInBezierPath = [UIBezierPath bezierPathWithRect:borderInRect];
	[angleOutBezierPath appendPath:borderOutBezierPath];
	[borderOutBezierPath appendPath:borderInBezierPath];
	
	NSArray *angleLineRelativeRectValueArray = @[[NSValue valueWithCGRect:CGRectMake(angleLineLength, 0, angleOutRect.size.width - angleLineLength * 2, angleLineWidth)],
									[NSValue valueWithCGRect:CGRectMake(0, angleLineLength, angleLineWidth, angleOutRect.size.height - angleLineLength * 2)],
									[NSValue valueWithCGRect:CGRectMake(angleLineLength, angleOutRect.size.height - angleLineWidth, angleOutRect.size.width - angleLineLength * 2, angleLineWidth)],
									[NSValue valueWithCGRect:CGRectMake(angleOutRect.size.width - angleLineWidth, angleLineLength, angleLineWidth, angleOutRect.size.height - angleLineLength * 2)]];
	for (NSValue *rectValue in angleLineRelativeRectValueArray) {
		CGRect angleLineRect = [rectValue CGRectValue];
		angleLineRect.origin.x += self.scanfRect.origin.x;
		angleLineRect.origin.y += self.scanfRect.origin.y;
		UIBezierPath *angleLineBezierPath = [UIBezierPath bezierPathWithRect:angleLineRect];
		[angleOutBezierPath appendPath:angleLineBezierPath];
	}
	
	[angleLineColor setFill];
	[angleOutBezierPath fill];
	
	[borderLineColor setFill];
	[borderOutBezierPath fill];
	
	UIBezierPath *scanfMaskBezierPath = [UIBezierPath bezierPathWithRect:rect];
	[scanfMaskBezierPath appendPath:borderInBezierPath];
	
	self.scanfMaskLayer.path = scanfMaskBezierPath.CGPath;
	
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	if (!self.dragAble) {
		return;
	}
	CGPoint location = [touches.anyObject locationInView:self];
	self.beginPoint = location;
	CGSize centerRectSize = CGSizeMake(self.scanfRect.size.width / 2, self.scanfRect.size.height / 2);
	CGSize angleRectSize = CGSizeMake(20, 20);
	NSArray *hotPointRectValueArray = @[
		[NSValue valueWithCGRect:self.scanfRect],
		[NSValue valueWithCGRect:CGRectInset(self.scanfRect, (self.scanfRect.size.width - centerRectSize.width) / 2, (self.scanfRect.size.height - centerRectSize.height) / 2)],
		[NSValue valueWithCGRect:(CGRect){self.scanfRect.origin.x + angleRectSize.width / 2, self.scanfRect.origin.y - angleRectSize.height / 2, self.scanfRect.size.width - angleRectSize.width, angleRectSize.height}],
		[NSValue valueWithCGRect:(CGRect){self.scanfRect.origin.x - angleRectSize.width / 2, self.scanfRect.origin.y + angleRectSize.height / 2, angleRectSize.width, self.scanfRect.size.height - angleRectSize.height}],
		[NSValue valueWithCGRect:(CGRect){self.scanfRect.origin.x + angleRectSize.width / 2, self.scanfRect.origin.y + self.scanfRect.size.height - angleRectSize.height / 2, self.scanfRect.size.width - angleRectSize.width, angleRectSize.height}],
		[NSValue valueWithCGRect:(CGRect){self.scanfRect.origin.x + self.scanfRect.size.width - angleRectSize.width / 2, self.scanfRect.origin.y + angleRectSize.height / 2, angleRectSize.width, self.scanfRect.size.height - angleRectSize.height}],
		[NSValue valueWithCGRect:(CGRect){self.scanfRect.origin.x - angleRectSize.width / 2, self.scanfRect.origin.y - angleRectSize.height / 2, angleRectSize}],
		[NSValue valueWithCGRect:(CGRect){self.scanfRect.origin.x - angleRectSize.width / 2, self.scanfRect.origin.y + self.scanfRect.size.height - angleRectSize.height / 2, angleRectSize}],
		[NSValue valueWithCGRect:(CGRect){self.scanfRect.origin.x + self.scanfRect.size.width - angleRectSize.width / 2, self.scanfRect.origin.y + self.scanfRect.size.height - angleRectSize.height / 2, angleRectSize}],
		[NSValue valueWithCGRect:(CGRect){self.scanfRect.origin.x + self.scanfRect.size.width - angleRectSize.width / 2, self.scanfRect.origin.y - angleRectSize.height / 2, angleRectSize}]
	];
	[hotPointRectValueArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		CGRect hotPointRect = [obj CGRectValue];
		if (CGRectContainsPoint(hotPointRect, location)) {
			self.dragStyle = idx;
		}
	}];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	CGPoint location = [touches.anyObject locationInView:self];
	CGFloat positionX = location.x - self.beginPoint.x;
	CGFloat positionY = location.y - self.beginPoint.y;
	self.beginPoint = location;
	CGRect scanfRect = self.scanfRect;
	switch (self.dragStyle) {
		case HTScanfDragStyleCenterNone: {
			break;
		}
		case HTScanfDragStyleCenter: {
			scanfRect.origin.x += positionX;
			scanfRect.origin.y += positionY;
			break;
		}
		case HTScanfDragStyleTop: {
			scanfRect.origin.y += positionY;
			scanfRect.size.height -= positionY;
			break;
		}
		case HTScanfDragStyleLeft: {
			scanfRect.origin.x += positionX;
			scanfRect.size.width -= positionX;
			break;
		}
		case HTScanfDragStyleBottom: {
			scanfRect.size.height += positionY;
			break;
		}
		case HTScanfDragStyleRight: {
			scanfRect.size.width += positionX;
			break;
		}
		case HTScanfDragStyleTopLeft: {
			scanfRect.origin.x += positionX;
			scanfRect.size.width -= positionX;
			scanfRect.origin.y += positionY;
			scanfRect.size.height -= positionY;
			break;
		}
		case HTScanfDragStyleLeftBottom: {
			scanfRect.origin.x += positionX;
			scanfRect.size.width -= positionX;
			scanfRect.size.height += positionY;
			break;
		}
		case HTScanfDragStyleBottomRight: {
			scanfRect.size.width += positionX;
			scanfRect.size.height += positionY;
			break;
		}
		case HTScanfDragStyleRightTop: {
			scanfRect.size.width += positionX;
			scanfRect.origin.y += positionY;
			scanfRect.size.height -= positionY;
			break;
		}
	}
	self.scanfRect = scanfRect;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	self.beginPoint = CGPointZero;
	self.dragStyle = HTScanfDragStyleCenterNone;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[self touchesEnded:touches withEvent:event];
}



- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	self.scanfRect = CGRectInset((CGRect){0, 0, frame.size}, MIN(50, frame.size.width / 2), MIN(140, frame.size.height / 2));
}

- (void)setBounds:(CGRect)bounds {
	[super setBounds:bounds];
	self.scanfRect = CGRectInset(bounds, MIN(50, bounds.size.width / 2), MIN(140, bounds.size.height / 2));
}

- (void)setScanfRect:(CGRect)scanfRect {
	scanfRect.origin.x = MAX(0, MIN(scanfRect.origin.x, self.bounds.size.width - 50));
	scanfRect.origin.y = MAX(0, MIN(scanfRect.origin.y, self.bounds.size.height - 50));
	scanfRect.size.width = MAX(50, MIN(scanfRect.size.width, self.bounds.size.width - scanfRect.origin.x));
	scanfRect.size.height = MAX(50, MIN(scanfRect.size.height, self.bounds.size.height - scanfRect.origin.y));
	_scanfRect = scanfRect;
	[self setNeedsDisplay];
}

- (CAShapeLayer *)scanfMaskLayer {
	if (!_scanfMaskLayer) {
		_scanfMaskLayer = [CAShapeLayer layer];
		_scanfMaskLayer.fillRule = kCAFillRuleEvenOdd;
	}
	return _scanfMaskLayer;
}

@end
