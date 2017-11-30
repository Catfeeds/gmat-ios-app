//
//  HTLeftCell.m
//  GMat
//
//  Created by hublot on 2016/10/21.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTLeftCell.h"
#import "HTLeftModel.h"

@interface HTLeftCell ()

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) CAShapeLayer *highlightShapeLayer;

@end

#ifdef __IPHONE_10_0

@interface HTLeftCell () <CAAnimationDelegate>

@end

#endif

@implementation HTLeftCell

- (void)didMoveToSuperview {
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	self.backgroundColor = [UIColor clearColor];
	self.layer.masksToBounds = true;
	[self.layer addSublayer:self.highlightShapeLayer];
	[self addSubview:self.titleNameLabel];
	[self.titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsMake(0, HTADAPT568(40), 0, 0));
	}];
}

- (void)setModel:(HTLeftModel *)model row:(NSInteger)row {
	self.titleNameLabel.text = model.titleName;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.font = [UIFont ht_fontStyle:HTFontStyleHeadSmall];
		_titleNameLabel.textColor = [UIColor whiteColor];
	}
	return _titleNameLabel;
}

- (CAShapeLayer *)highlightShapeLayer {
	if (!_highlightShapeLayer) {
		_highlightShapeLayer = [CAShapeLayer layer];
		_highlightShapeLayer.fillColor = [UIColor ht_colorStyle:HTColorStylePrimaryTheme].CGColor;
	}
	return _highlightShapeLayer;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
	[self.highlightShapeLayer removeAllAnimations];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	NSEnumerator *enumerator = [touches objectEnumerator];
	UITouch *touch = [enumerator nextObject];
	CGPoint point = [touch locationInView:self];
	CABasicAnimation *baseRadiusAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
	baseRadiusAnimation.removedOnCompletion = false;
	baseRadiusAnimation.fillMode = kCAFillModeForwards;
	baseRadiusAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	baseRadiusAnimation.duration = 1;
	baseRadiusAnimation.fromValue = (id)[UIBezierPath bezierPathWithArcCenter:point radius:1 startAngle:0 endAngle:M_PI * 2 clockwise:true].CGPath;
	baseRadiusAnimation.toValue = (id)[UIBezierPath bezierPathWithArcCenter:point radius:MAX(self.ht_w, self.ht_h) startAngle:0 endAngle:M_PI * 2 clockwise:true].CGPath;
	[self.highlightShapeLayer removeAllAnimations];
	[self.highlightShapeLayer addAnimation:baseRadiusAnimation forKey:nil];
}

- (void)removeAnimation {
	CABasicAnimation *baseColorAnimation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
	baseColorAnimation.delegate = self;
	baseColorAnimation.removedOnCompletion = false;
	baseColorAnimation.fillMode = kCAFillModeForwards;
	baseColorAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	baseColorAnimation.duration = 0.25;
	baseColorAnimation.fromValue = (id)[UIColor colorWithCGColor:self.highlightShapeLayer.fillColor].CGColor;
	baseColorAnimation.toValue = (id)[UIColor clearColor].CGColor;
	[self.highlightShapeLayer addAnimation:baseColorAnimation forKey:nil];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
	[self removeAnimation];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesCancelled:touches withEvent:event];
	[self removeAnimation];
}

@end
