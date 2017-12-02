//
//  THExerciseExamListenAnswerNavigationButton.m
//  TingApp
//
//  Created by hublot on 16/9/13.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "THExerciseExamListenAnswerNavigationButton.h"

@interface THExerciseExamListenAnswerNavigationButton ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation THExerciseExamListenAnswerNavigationButton

- (void)didMoveToSuperview {
	[super didMoveToSuperview];
	[self.layer addSublayer:self.shapeLayer];
	[self addSubview:self.titleNameLabel];
	self.titleLabel.font = [UIFont systemFontOfSize:0];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.titleNameLabel.ht_w = 36;
	self.titleNameLabel.ht_h = self.titleNameLabel.ht_w;
	self.titleNameLabel.layer.cornerRadius = 18;
	self.titleNameLabel.layer.masksToBounds = true;
	self.titleNameLabel.center = CGPointMake(self.ht_w / 2, self.ht_h / 2);
	self.titleNameLabel.frame = self.titleNameLabel.frame;
	self.shapeLayer.frame = CGRectMake(CGRectGetMidX(self.titleNameLabel.frame), CGRectGetMaxY(self.titleNameLabel.frame), 10, 4);
}

- (void)setModel:(HTQuestionModel *)model {
	UIColor *answerTintColor = [model.userAnswer isEqualToString:model.trueAnswer] ? [UIColor ht_colorStyle:HTColorStyleAnswerRight] : [UIColor ht_colorStyle:HTColorStyleAnswerWrong];
	self.titleNameLabel.layer.borderColor = answerTintColor.CGColor;
	
	__weak THExerciseExamListenAnswerNavigationButton *weakSelf = self;
	[self bk_removeAllBlockObservers];
	[self bk_addObserverForKeyPath:@"selected" options:NSKeyValueObservingOptionInitial task:^(id obj, NSDictionary *change) {
		if (weakSelf.selected) {
			weakSelf.titleNameLabel.textColor = [UIColor whiteColor];
			weakSelf.shapeLayer.fillColor = answerTintColor.CGColor;
			weakSelf.titleNameLabel.backgroundColor = answerTintColor;
		} else {
			weakSelf.titleNameLabel.textColor = answerTintColor;
			weakSelf.shapeLayer.fillColor = [UIColor clearColor].CGColor;
			weakSelf.titleNameLabel.backgroundColor = [UIColor clearColor];
		}
	}];
}

- (CAShapeLayer *)shapeLayer {
	if (!_shapeLayer) {
		_shapeLayer = [CAShapeLayer layer];
		UIBezierPath *bezierPath = [UIBezierPath bezierPath];
		[bezierPath moveToPoint:CGPointMake(CGRectGetMidX(self.titleNameLabel.frame) - 5, CGRectGetMaxY(self.titleNameLabel.frame) - 1)];
		[bezierPath addLineToPoint:CGPointMake(CGRectGetMidX(self.titleNameLabel.frame), CGRectGetMaxY(self.titleNameLabel.frame) + 3)];
		[bezierPath addLineToPoint:CGPointMake(CGRectGetMidX(self.titleNameLabel.frame) + 5, CGRectGetMaxY(self.titleNameLabel.frame) - 1)];
		_shapeLayer.path = bezierPath.CGPath;
		_shapeLayer.strokeColor = [UIColor clearColor].CGColor;
	}
	return _shapeLayer;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.textAlignment = NSTextAlignmentCenter;
		
		__weak THExerciseExamListenAnswerNavigationButton *weakSelf = self;
		[self.titleLabel bk_addObserverForKeyPath:@"text" options:NSKeyValueObservingOptionInitial task:^(id obj, NSDictionary *change) {
			weakSelf.titleNameLabel.text = weakSelf.titleLabel.text;
		}];
	}
	return _titleNameLabel;
}


@end
