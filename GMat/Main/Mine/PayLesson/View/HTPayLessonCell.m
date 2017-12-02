//
//  HTPayLessonCell.m
//  GMat
//
//  Created by hublot on 2016/11/4.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTPayLessonCell.h"
#import "HTCourseOnlineVideoModel.h"

@interface HTPayLessonCell ()

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UILabel *teacherNameLabel;

@property (nonatomic, strong) UILabel *lessonTimeLabel;

@property (nonatomic, strong) UILabel *lessonMoneyLabel;

@property (nonatomic, strong) UIButton *payLessonButton;

@end

@implementation HTPayLessonCell

- (void)didMoveToSuperview {
	[self.contentView addSubview:self.headImageView];
	[self.contentView addSubview:self.titleNameLabel];
	[self.contentView addSubview:self.teacherNameLabel];
	[self.contentView addSubview:self.lessonTimeLabel];
	[self.contentView addSubview:self.lessonMoneyLabel];
	[self.contentView addSubview:self.payLessonButton];
	[self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self).offset(15);
		make.top.mas_equalTo(self).offset(10);
		make.bottom.mas_equalTo(self).offset(- 10);
		make.width.mas_equalTo(self.headImageView.mas_height).multipliedBy(4.0 / 3);
	}];
	[self.titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.headImageView);
		make.left.mas_equalTo(self.headImageView.mas_right).offset(10);
		make.right.mas_lessThanOrEqualTo(self.lessonMoneyLabel.mas_left).offset(- 10).priority(999);
	}];
	[self.teacherNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.mas_equalTo(self.lessonTimeLabel.mas_top);
		make.left.mas_equalTo(self.titleNameLabel);
		make.right.mas_lessThanOrEqualTo(self.payLessonButton.mas_left).offset(- 10).priority(999);
	}];
	[self.lessonTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.mas_equalTo(self.headImageView).offset(- 10);
		make.left.mas_equalTo(self.titleNameLabel);
		make.right.mas_lessThanOrEqualTo(self.payLessonButton.mas_left).offset(- 10).priority(999);
	}];
	[self.lessonMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.mas_equalTo(self).offset(- 15);
		make.top.mas_equalTo(self.titleNameLabel);
	}];
	[self.payLessonButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.mas_equalTo(self.lessonMoneyLabel);
		make.bottom.mas_equalTo(self.headImageView);
		make.width.mas_equalTo(HTADAPT568(70));
		make.height.mas_equalTo(HTADAPT568(25));
	}];
}

- (void)setModel:(HTCourseOnlineVideoModel *)model row:(NSInteger)row {
	[self.headImageView sd_setImageWithURL:[NSURL URLWithString:GmatResourse(model.contentthumb)] placeholderImage:HTPLACEHOLDERIMAGE];
	self.titleNameLabel.text = model.contenttitle;
	self.teacherNameLabel.text = [NSString stringWithFormat:@"主讲:%@", model.teacher];
	self.lessonTimeLabel.text = [NSString stringWithFormat:@"开课时间:%@", model.time];
	self.lessonMoneyLabel.text = [NSString stringWithFormat:@"¥ %@", model.price];
	NSString *payLessonTitle;
	UIColor *payLessonBackgroundColor;
	if (model.status.integerValue == 0) {
		payLessonTitle = @"点击付款";
		payLessonBackgroundColor = [UIColor ht_colorStyle:HTColorStyleAnswerWrong];
	} else {
		payLessonTitle = @"点击购买";
		payLessonBackgroundColor = [UIColor ht_colorStyle:HTColorStylePrimaryTheme];
	}
	[self.payLessonButton setTitle:payLessonTitle forState:UIControlStateNormal];
	[self.payLessonButton setBackgroundColor:payLessonBackgroundColor];
}

- (UIImageView *)headImageView {
	if (!_headImageView) {
		_headImageView = [[UIImageView alloc] init];
	}
	return _headImageView;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_titleNameLabel.font = [UIFont ht_fontStyle:HTFontStyleTitleSmall];
	}
	return _titleNameLabel;
}

- (UILabel *)teacherNameLabel {
	if (!_teacherNameLabel) {
		_teacherNameLabel = [[UILabel alloc] init];
		_teacherNameLabel.textColor = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
		_teacherNameLabel.font = [UIFont ht_fontStyle:HTFontStyleDetailLarge];
	}
	return _teacherNameLabel;
}

- (UILabel *)lessonTimeLabel {
	if (!_lessonTimeLabel) {
		_lessonTimeLabel = [[UILabel alloc] init];
		_lessonTimeLabel.textColor = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
		_lessonTimeLabel.font = [UIFont ht_fontStyle:HTFontStyleDetailLarge];
	}
	return _lessonTimeLabel;
}

- (UILabel *)lessonMoneyLabel {
	if (!_lessonMoneyLabel) {
		_lessonMoneyLabel = [[UILabel alloc] init];
		_lessonMoneyLabel.textColor = [UIColor ht_colorStyle:HTColorStyleAnswerWrong];
		_lessonMoneyLabel.font = [UIFont ht_fontStyle:HTFontStyleTitleSmall];
		_lessonMoneyLabel.textAlignment = NSTextAlignmentRight;
		[_lessonMoneyLabel setContentHuggingPriority:300 forAxis:UILayoutConstraintAxisHorizontal];
		[_lessonMoneyLabel setContentCompressionResistancePriority:800 forAxis:UILayoutConstraintAxisHorizontal];
	}
	return _lessonMoneyLabel;
}

- (UIButton *)payLessonButton {
	if (!_payLessonButton) {
		_payLessonButton = [[UIButton alloc] init];
		_payLessonButton.userInteractionEnabled = false;
		[_payLessonButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		_payLessonButton.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleDetailLarge];
		_payLessonButton.layer.cornerRadius = 3;
		_payLessonButton.layer.masksToBounds = true;
		[_payLessonButton setContentHuggingPriority:300 forAxis:UILayoutConstraintAxisHorizontal];
		[_payLessonButton setContentCompressionResistancePriority:800 forAxis:UILayoutConstraintAxisHorizontal];
	}
	return _payLessonButton;
}


@end
