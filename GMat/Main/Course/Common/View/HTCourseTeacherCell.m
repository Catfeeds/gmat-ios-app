//
//  HTCourseTeacherView.m
//  GMat
//
//  Created by hublot on 2017/4/19.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTCourseTeacherCell.h"
#import "THCourseTogetherTeacherModel.h"

@interface HTCourseTeacherCell ()

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UILabel *detailNameLabel;

@property (nonatomic, strong) UILabel *lookTeacherLabel;

@property (nonatomic, strong) UILabel *togetherCountLabel;

@end

@implementation HTCourseTeacherCell

- (void)didMoveToSuperview {
	[self addSubview:self.headImageView];
	[self addSubview:self.titleNameLabel];
	[self addSubview:self.detailNameLabel];
	[self addSubview:self.lookTeacherLabel];
	[self addSubview:self.joinTogetherButton];
	[self addSubview:self.togetherCountLabel];
	[self.headImageView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self).offset(15);
		make.top.mas_equalTo(self).offset(15);
		make.width.height.mas_equalTo(65);
	}];
	[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.headImageView).offset(10);
		make.left.mas_equalTo(self.headImageView.mas_right).offset(10);
		make.right.mas_equalTo(self);
	}];
	[self.detailNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.titleNameLabel.mas_bottom).offset(10);
		make.left.mas_equalTo(self.headImageView.mas_right).offset(10);
		make.right.mas_equalTo(self);
		make.bottom.mas_lessThanOrEqualTo(self.joinTogetherButton.mas_top).offset(- 10).priority(999);
	}];
	[self.lookTeacherLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.bottom.mas_equalTo(self.togetherCountLabel.mas_top);
		make.left.mas_equalTo(self.headImageView.mas_right).offset(10);
	}];
	[self.joinTogetherButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.right.mas_equalTo(self).offset(- 10);
		make.bottom.mas_equalTo(self.togetherCountLabel.mas_top).offset(- 5);
		make.width.mas_equalTo(80);
		make.height.mas_equalTo(25);
	}];
	[self.togetherCountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.right.mas_equalTo(self).offset(- 10);
		make.bottom.mas_equalTo(self).offset(- 10);
	}];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.headImageView.layer.cornerRadius = self.headImageView.bounds.size.height / 2;
	self.headImageView.layer.masksToBounds = true;
	self.headImageView.layer.borderColor = [UIColor ht_colorString:@"ff9b01"].CGColor;
	self.headImageView.layer.borderWidth = 1;
	self.joinTogetherButton.layer.cornerRadius = self.joinTogetherButton.bounds.size.height / 2;
	self.joinTogetherButton.layer.masksToBounds = true;
}

- (void)setModel:(THCourseTogetherTeacherModel *)model row:(NSInteger)row {
	[self.headImageView sd_setImageWithURL:[NSURL URLWithString:GmatResourse(model.teacherIamge)] placeholderImage:HTPLACEHOLDERIMAGE];
	self.titleNameLabel.text = model.teacherName;
	self.detailNameLabel.text = model.introduceAttributedString.string;
    self.togetherCountLabel.text = [NSString stringWithFormat:@"已约: %ld", model.joinTimes];
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
		_titleNameLabel.font = [UIFont systemFontOfSize:14];
		[_titleNameLabel setContentHuggingPriority:300 forAxis:UILayoutConstraintAxisHorizontal];
		[_titleNameLabel setContentCompressionResistancePriority:800 forAxis:UILayoutConstraintAxisHorizontal];
	}
	return _titleNameLabel;
}

- (UILabel *)detailNameLabel {
	if (!_detailNameLabel) {
		_detailNameLabel = [[UILabel alloc] init];
		_detailNameLabel.textColor = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
		_detailNameLabel.font = [UIFont systemFontOfSize:13];
		_detailNameLabel.numberOfLines = 0;
	}
	return _detailNameLabel;
}

- (UILabel *)lookTeacherLabel {
	if (!_lookTeacherLabel) {
		_lookTeacherLabel = [[UILabel alloc] init];
		_lookTeacherLabel.textColor = [UIColor ht_colorString:@"ff9b01"];
		_lookTeacherLabel.font = [UIFont systemFontOfSize:13];
		_lookTeacherLabel.text = @"查看老师详情 >";
	}
	return _lookTeacherLabel;
}

- (UIButton *)joinTogetherButton {
	if (!_joinTogetherButton) {
		_joinTogetherButton = [[UIButton alloc] init];
		_joinTogetherButton.titleLabel.font = [UIFont systemFontOfSize:13];
		[_joinTogetherButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		_joinTogetherButton.backgroundColor = [UIColor ht_colorString:@"ff9b01"];
		[_joinTogetherButton setTitle:@"约课" forState:UIControlStateNormal];
		[_joinTogetherButton setContentHuggingPriority:300 forAxis:UILayoutConstraintAxisVertical];
		[_joinTogetherButton setContentCompressionResistancePriority:800 forAxis:UILayoutConstraintAxisVertical];
	}
	return _joinTogetherButton;
}

- (UILabel *)togetherCountLabel {
	if (!_togetherCountLabel) {
		_togetherCountLabel = [[UILabel alloc] init];
		_togetherCountLabel.font = [UIFont systemFontOfSize:13];
		_togetherCountLabel.textColor = [UIColor ht_colorString:@"ff9b01"];
		[_togetherCountLabel setContentHuggingPriority:300 forAxis:UILayoutConstraintAxisVertical];
		[_togetherCountLabel setContentCompressionResistancePriority:800 forAxis:UILayoutConstraintAxisVertical];
	}
	return _togetherCountLabel;
}

@end
