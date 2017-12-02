//
//  HTCourseTryListenView.m
//  GMat
//
//  Created by hublot on 2017/4/19.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTCourseTryListenView.h"
#import "HTTryListenModel.h"

@interface HTCourseTryListenView ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIView *backgroundColorView;

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UIButton *tryListenButton;

@property (nonatomic, strong) UILabel *italicTimesLabel;

@end

@implementation HTCourseTryListenView

- (void)setModel:(HTTryListenModel *)model row:(NSInteger)row {
	self.layer.masksToBounds = true;
	[self addSubview:self.backgroundImageView];
	[self addSubview:self.backgroundColorView];
	
	[self.backgroundColorView addSubview:self.titleNameLabel];
	[self.backgroundColorView addSubview:self.tryListenButton];
	
	[self addSubview:self.italicTimesLabel];
	

	self.backgroundImageView.image = [UIImage imageNamed:model.backgroundImage];
	
//	self.backgroundColorView.backgroundColor = [UIColor ht_colorString:model.tintColor];
	[self.tryListenButton setTitleColor:[UIColor ht_colorString:model.tintColor] forState:UIControlStateNormal];
	
	NSString *titleString = [NSString stringWithFormat:@"%@\n%@\n%@", model.catname, model.teacherName, model.times];
	NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	paragraphStyle.lineSpacing = 5;
	
	NSDictionary *normalDictionary = @{NSForegroundColorAttributeName:[UIColor whiteColor],
									   NSFontAttributeName:[UIFont systemFontOfSize:11]};
	NSDictionary *selectedDictionary = @{NSForegroundColorAttributeName:[UIColor whiteColor],
										 NSFontAttributeName:[UIFont systemFontOfSize:11]};
	NSMutableAttributedString *countAttributedString = [[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld\n", model.playTimes] attributes:selectedDictionary] mutableCopy];
	NSAttributedString *appendAttributedString = [[NSAttributedString alloc] initWithString:@"播放\n" attributes:normalDictionary];
	[countAttributedString appendAttributedString:appendAttributedString];
	self.italicTimesLabel.attributedText = countAttributedString;
	
	CGFloat tryListenButtonHeight = 25;
	self.tryListenButton.layer.cornerRadius = tryListenButtonHeight / 2;

	if (row == 0) {
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
			make.width.mas_equalTo(self).multipliedBy(0.65);
		}];
		
		[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
			make.left.mas_equalTo(self.backgroundColorView).offset(5);
			make.top.mas_equalTo(self.backgroundColorView).offset(25);
			make.right.mas_equalTo(self.backgroundColorView);
		}];
		
		[self.tryListenButton mas_updateConstraints:^(MASConstraintMaker *make) {
			make.bottom.mas_equalTo(self).offset(- 10);
			make.width.mas_equalTo(60);
			make.height.mas_equalTo(tryListenButtonHeight);
			make.centerX.mas_equalTo(self.backgroundColorView);
		}];
		
		[self.italicTimesLabel mas_updateConstraints:^(MASConstraintMaker *make) {
			make.top.mas_equalTo(0);
			make.right.mas_equalTo(- 10);
			make.width.mas_equalTo(50);
			make.height.mas_equalTo(60);
		}];
		
	} else if (row == 1 || row == 2) {
		[self.backgroundImageView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.left.mas_equalTo(self);
			make.top.mas_equalTo(self);
			make.right.mas_equalTo(self);
			make.bottom.mas_equalTo(self);
		}];
		
		[self.backgroundColorView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.left.mas_equalTo(self);
			make.bottom.mas_equalTo(self);
			make.width.mas_equalTo(self);
			make.height.mas_equalTo(self).multipliedBy(0.5);
		}];
		
		
		[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
			make.left.mas_equalTo(self.backgroundColorView).mas_equalTo(5);
			make.top.mas_equalTo(self.backgroundColorView).offset(5);
			make.right.mas_equalTo(self.backgroundColorView);
		}];
		[self.tryListenButton mas_updateConstraints:^(MASConstraintMaker *make) {
			make.bottom.mas_equalTo(self.backgroundColorView).mas_offset(- 10);
			make.right.mas_equalTo(self.backgroundColorView).mas_offset(- 5);
			make.width.mas_equalTo(60);
			make.height.mas_equalTo(tryListenButtonHeight);
		}];
	} else if (row == 3) {
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
			make.width.mas_equalTo(self).multipliedBy(0.6);
		}];
		
		paragraphStyle.alignment = NSTextAlignmentRight;
		
		[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
			make.left.mas_equalTo(self.backgroundColorView);
			make.top.mas_equalTo(self.backgroundColorView).offset(25);
			make.right.mas_equalTo(self.backgroundColorView).offset(- 5);
		}];
		
		[self.tryListenButton mas_updateConstraints:^(MASConstraintMaker *make) {
			make.bottom.mas_equalTo(self).offset(- 10);
			make.width.mas_equalTo(60);
			make.height.mas_equalTo(tryListenButtonHeight);
			make.centerX.mas_equalTo(self.backgroundColorView);
		}];
	}
	NSDictionary *dictionary = @{NSForegroundColorAttributeName:[UIColor whiteColor],
								 NSFontAttributeName:[UIFont systemFontOfSize:13],
								 NSParagraphStyleAttributeName:paragraphStyle};
	NSMutableAttributedString *attributedString = [[[NSAttributedString alloc] initWithString:titleString attributes:dictionary] mutableCopy];
	self.titleNameLabel.attributedText = attributedString;
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

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.numberOfLines = 0;
	}
	return _titleNameLabel;
}

- (UIButton *)tryListenButton {
	if (!_tryListenButton) {
		_tryListenButton = [[UIButton alloc] init];
		[_tryListenButton setTitle:@"去试听" forState:UIControlStateNormal];
		_tryListenButton.titleLabel.font = [UIFont systemFontOfSize:13];
		_tryListenButton.backgroundColor = [UIColor whiteColor];
		_tryListenButton.layer.masksToBounds = true;
        _tryListenButton.userInteractionEnabled = false;
	}
	return _tryListenButton;
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
