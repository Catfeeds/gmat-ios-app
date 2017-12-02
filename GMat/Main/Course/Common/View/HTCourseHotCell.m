//
//  HTCourseHotCell.m
//  GMat
//
//  Created by hublot on 2017/4/19.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTCourseHotCell.h"
#import "HTCourseHotModel.h"

@interface HTCourseHotCell ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIButton *playVideoButton;

@property (nonatomic, strong) UILabel *studyCountLabel;

@property (nonatomic, strong) UILabel *titleNameLabel;

@end

@implementation HTCourseHotCell

- (void)didMoveToSuperview {
	[self addSubview:self.backgroundImageView];
	[self addSubview:self.playVideoButton];
	[self addSubview:self.studyCountLabel];
	[self addSubview:self.titleNameLabel];
	
	CGFloat titleNameLabelHeight = 40;
	[self.backgroundImageView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.right.top.mas_equalTo(self);
		make.bottom.mas_equalTo(self.titleNameLabel.mas_top);
	}];
	[self.playVideoButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(50);
		make.center.mas_equalTo(self.backgroundImageView);
	}];
	[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.right.bottom.mas_equalTo(self);
		make.height.mas_equalTo(titleNameLabelHeight);
	}];
}

- (void)setModel:(HTCourseHotModel *)model row:(NSInteger)row {
	self.titleNameLabel.text = model.result.contenttitle;
	NSString *viewCount = [NSString stringWithFormat:@"%ld", model.joinTimes];
	[self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:GmatResourse(model.result.contentthumb)] placeholderImage:HTPLACEHOLDERIMAGE];
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%@人上课\n", viewCount]];
	[attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],
									  NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, attributedString.length)];
	self.studyCountLabel.attributedText = attributedString;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.playVideoButton.layer.cornerRadius = self.playVideoButton.bounds.size.height / 2;
	self.playVideoButton.layer.masksToBounds = true;
}

- (UIImageView *)backgroundImageView {
	if (!_backgroundImageView) {
		_backgroundImageView = [[UIImageView alloc] init];
		_backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
		_backgroundImageView.clipsToBounds = true;
	}
	return _backgroundImageView;
}

- (UIButton *)playVideoButton {
	if (!_playVideoButton) {
		_playVideoButton = [[UIButton alloc] init];
		_playVideoButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
		[_playVideoButton setImage:[UIImage imageNamed:@"CourseHotCollectionCellPlay"] forState:UIControlStateNormal];
		_playVideoButton.imageEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
        _playVideoButton.userInteractionEnabled = false;
	}
	return _playVideoButton;
}

- (UILabel *)studyCountLabel {
	if (!_studyCountLabel) {
		_studyCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 50, 60)];
		_studyCountLabel.backgroundColor = [[UIColor ht_colorString:@"f95a5a"] colorWithAlphaComponent:0.85];
		_studyCountLabel.textAlignment = NSTextAlignmentCenter;
        _studyCountLabel.numberOfLines = 0;
		CAShapeLayer *shapeLayer = [CAShapeLayer layer];
		UIBezierPath *bezierPath = [UIBezierPath bezierPath];
		[bezierPath moveToPoint:CGPointMake(0, 60)];
		[bezierPath addLineToPoint:CGPointMake(50 / 2, 60 - 15)];
		[bezierPath addLineToPoint:CGPointMake(50, 60)];
		[bezierPath closePath];
		[bezierPath appendPath:[UIBezierPath bezierPathWithRect:_studyCountLabel.bounds]];
		shapeLayer.path = bezierPath.CGPath;
		shapeLayer.fillRule = kCAFillRuleEvenOdd;
		_studyCountLabel.layer.mask = shapeLayer;
	}
	return _studyCountLabel;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
		_titleNameLabel.font = [UIFont systemFontOfSize:15];
		_titleNameLabel.textColor = [UIColor whiteColor];
		_titleNameLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _titleNameLabel;
}

@end
