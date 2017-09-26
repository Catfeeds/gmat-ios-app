//
//  HTCourseBeginView.m
//  GMat
//
//  Created by hublot on 2017/4/19.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTCourseBeginView.h"

@interface HTCourseBeginView ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIView *backgroundColorView;

@property (nonatomic, strong) UIView *triangleView;

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UILabel *italicTimesLabel;

@end

@implementation HTCourseBeginView

- (void)setModel:(HTCourseBeginModel *)model row:(NSInteger)row {
	self.layer.masksToBounds = true;
	[self addSubview:self.backgroundImageView];
	[self addSubview:self.backgroundColorView];
	
	[self addSubview:self.triangleView];
	
	[self.backgroundColorView addSubview:self.titleNameLabel];
	
	[self addSubview:self.italicTimesLabel];
	
	self.backgroundImageView.image = [UIImage imageNamed:model.backgroundImage];
//	self.backgroundColorView.backgroundColor = [UIColor ht_colorString:model.tintColor];
	[self.triangleView.layer.sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if ([obj isKindOfClass:[CAShapeLayer class]]) {
			CAShapeLayer *shapeLayer = (CAShapeLayer *)obj;
			shapeLayer.fillColor = [UIColor ht_colorString:model.tintColor].CGColor;
		}
	}];
	
	NSString *titleString = [NSString stringWithFormat:@"%@\n课时:%@", model.catname, model.times];
	NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	paragraphStyle.lineSpacing = 5;
	paragraphStyle.alignment = NSTextAlignmentCenter;
	
	NSDictionary *dictionary = @{NSFontAttributeName:[UIFont systemFontOfSize:13],
								 NSForegroundColorAttributeName:[UIColor whiteColor],
								 NSParagraphStyleAttributeName:paragraphStyle};
	NSMutableAttributedString *attributedString = [[[NSAttributedString alloc] initWithString:titleString attributes:dictionary] mutableCopy];
	self.titleNameLabel.attributedText = attributedString;
	
	NSDictionary *normalDictionary = @{NSForegroundColorAttributeName:[UIColor whiteColor],
									   NSFontAttributeName:[UIFont systemFontOfSize:11]};
	NSDictionary *selectedDictionary = @{NSForegroundColorAttributeName:[UIColor whiteColor],
										 NSFontAttributeName:[UIFont systemFontOfSize:11]};
	NSMutableAttributedString *countAttributedString = [[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld\n", model.playTimes] attributes:selectedDictionary] mutableCopy];
	NSAttributedString *appendAttributedString = [[NSAttributedString alloc] initWithString:@"播放\n" attributes:normalDictionary];
	[countAttributedString appendAttributedString:appendAttributedString];
	self.italicTimesLabel.attributedText = countAttributedString;
	
	
	self.triangleView.hidden = true;
	
	if (row == 0) {
		[self.backgroundImageView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.right.mas_equalTo(self);
			make.top.mas_equalTo(self);
			make.left.mas_equalTo(self);
			make.bottom.mas_equalTo(self);
		}];

		[self.backgroundColorView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.right.mas_equalTo(self);
			make.top.mas_equalTo(self);
			make.bottom.mas_equalTo(self);
			make.width.mas_equalTo(self).multipliedBy(0.5);
		}];
		[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
			make.left.mas_equalTo(self.backgroundColorView);
			make.right.mas_equalTo(self.backgroundColorView);
			make.top.mas_equalTo(self.backgroundColorView).offset(30);
		}];
		
		[self.triangleView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.centerY.mas_equalTo(self.backgroundColorView);
			make.right.mas_equalTo(self.backgroundColorView.mas_left);
		}];
		
		self.triangleView.transform = CGAffineTransformMakeRotation(M_PI);

		
	} else if (row == 1) {
		[self.backgroundImageView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.left.mas_equalTo(self);
			make.top.mas_equalTo(self);
			make.right.mas_equalTo(self);
			make.bottom.mas_equalTo(self);
		}];
		
		[self.backgroundColorView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.left.mas_equalTo(self);
			make.top.mas_equalTo(self);
			make.bottom.mas_equalTo(self);
			make.width.mas_equalTo(self).multipliedBy(0.5);
		}];
		[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
			make.left.mas_equalTo(self.backgroundColorView);
			make.right.mas_equalTo(self.backgroundColorView);
			make.top.mas_equalTo(self.backgroundColorView).offset(60);
		}];
		
		[self.triangleView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.centerY.mas_equalTo(self.backgroundColorView);
			make.left.mas_equalTo(self.backgroundColorView.mas_right);
		}];

	} else if (row == 2) {
		[self.backgroundImageView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.top.mas_equalTo(self);
			make.right.mas_equalTo(self);
			make.left.mas_equalTo(self);
			make.bottom.mas_equalTo(self);
		}];
		
		[self.backgroundColorView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.bottom.mas_equalTo(self);
			make.right.mas_equalTo(self);
			make.left.mas_equalTo(self);
			make.height.mas_equalTo(self).multipliedBy(0.5);
		}];
		
		[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
			make.left.mas_equalTo(self.backgroundColorView);
			make.right.mas_equalTo(self.backgroundColorView);
			make.top.mas_equalTo(self.backgroundColorView).offset(5);
		}];
		[self.triangleView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.bottom.mas_equalTo(self.backgroundColorView.mas_top);
			make.centerX.mas_equalTo(self.backgroundColorView);
		}];
		self.triangleView.transform = CGAffineTransformMakeRotation(- M_PI / 2);
		
	} else if (row == 3) {
		[self.backgroundImageView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.top.mas_equalTo(self);
			make.right.mas_equalTo(self);
			make.left.mas_equalTo(self);
			make.bottom.mas_equalTo(self);
		}];
		
		[self.backgroundColorView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.bottom.mas_equalTo(self);
			make.right.mas_equalTo(self);
			make.left.mas_equalTo(self);
			make.height.mas_equalTo(self).multipliedBy(0.5);
		}];
		
		[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
			make.left.mas_equalTo(self.backgroundColorView);
			make.right.mas_equalTo(self.backgroundColorView);
			make.top.mas_equalTo(self.backgroundColorView).offset(5);
		}];
		
		[self.triangleView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.bottom.mas_equalTo(self.backgroundColorView.mas_top);
			make.centerX.mas_equalTo(self.backgroundColorView);
		}];
		self.triangleView.transform = CGAffineTransformMakeRotation(- M_PI / 2);
		
	}
}

- (UIImageView *)backgroundImageView {
	if (!_backgroundImageView) {
		_backgroundImageView = [[UIImageView alloc] init];
		_backgroundImageView.contentMode = UIViewContentModeScaleToFill;
		_backgroundImageView.clipsToBounds = true;
	}
	return _backgroundImageView;
}

- (UIView *)backgroundColorView {
	if (!_backgroundColorView) {
		_backgroundColorView = [[UIView alloc] init];
	}
	return _backgroundColorView;
}

- (UIView *)triangleView {
	if (!_triangleView) {
		CGFloat triangleWidth = 8;
		_triangleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, triangleWidth, triangleWidth)];
		CAShapeLayer *shapeLayer = [CAShapeLayer layer];
		shapeLayer.fillColor = [UIColor orangeColor].CGColor;
		UIBezierPath *bezierPath = [UIBezierPath bezierPath];
		[bezierPath moveToPoint:CGPointMake(0, 0)];
		[bezierPath addLineToPoint:CGPointMake(triangleWidth - 2, triangleWidth / 2)];
		[bezierPath addLineToPoint:CGPointMake(0, triangleWidth)];
		[bezierPath closePath];
		shapeLayer.path = bezierPath.CGPath;
		[_triangleView.layer addSublayer:shapeLayer];
	}
	return _triangleView;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.numberOfLines = 0;
	}
	return _titleNameLabel;
}

- (UILabel *)italicTimesLabel {
	if (!_italicTimesLabel) {
		_italicTimesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 50, 60)];
		_italicTimesLabel.backgroundColor = [[UIColor ht_colorString:@"f95a5a"] colorWithAlphaComponent:0.85];
		_italicTimesLabel.textAlignment = NSTextAlignmentCenter;
		_italicTimesLabel.numberOfLines = 0;
		CAShapeLayer *shapeLayer = [CAShapeLayer layer];
		UIBezierPath *bezierPath = [UIBezierPath bezierPath];
		[bezierPath moveToPoint:CGPointMake(0, 60)];
		[bezierPath addLineToPoint:CGPointMake(50 / 2, 60 - 15)];
		[bezierPath addLineToPoint:CGPointMake(50, 60)];
		[bezierPath closePath];
		[bezierPath appendPath:[UIBezierPath bezierPathWithRect:_italicTimesLabel.bounds]];
		shapeLayer.path = bezierPath.CGPath;
		shapeLayer.fillRule = kCAFillRuleEvenOdd;
		_italicTimesLabel.layer.mask = shapeLayer;
	}
	return _italicTimesLabel;
}

@end
