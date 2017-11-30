//
//  THTogetherTeacherCell.m
//  TingApp
//
//  Created by hublot on 16/8/24.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "THTogetherTeacherCell.h"
#import "THCourseTogetherTeacherModel.h"
#import "NSString+HTString.h"

@interface THTogetherTeacherCell ()

@property (nonatomic, strong) UIButton *headImageButton;

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UILabel *detialNameLabel;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation THTogetherTeacherCell

- (void)didMoveToSuperview {
	[self addSubview:self.headImageButton];
	[self addSubview:self.titleNameLabel];
	[self addSubview:self.detialNameLabel];
	[self addSubview:self.lineView];
	[self addSubview:self.inviteButton];
	[self.headImageButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(15);
		make.top.mas_equalTo(25);
		make.bottom.mas_equalTo(- 25);
		make.width.mas_equalTo(self.headImageButton.mas_height);
	}];
	[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.headImageButton);
		make.left.mas_equalTo(self.lineView);
		make.right.mas_equalTo(self.inviteButton.mas_left).offset(- 10);
	}];
	[self.detialNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.lineView.mas_bottom).offset(10);
		make.left.mas_equalTo(self.titleNameLabel);
		make.right.mas_equalTo(self.lineView);
	}];
	[self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.titleNameLabel.mas_bottom).offset(15);
		make.left.mas_equalTo(self.headImageButton.mas_right).offset(10);
		make.right.mas_equalTo(- 15);
		make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
	}];
	[self.inviteButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.right.mas_equalTo(self.lineView);
		make.width.mas_equalTo(HTADAPT568(85));
		make.height.mas_equalTo(HTADAPT568(30));
		make.centerY.mas_equalTo(self.titleNameLabel);
	}];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.headImageButton.layer.cornerRadius = self.headImageButton.ht_w / 2;
}

- (void)setModel:(THCourseTogetherTeacherModel *)model row:(NSInteger)row {
	self.titleNameLabel.text = model.teacherName;
    self.detialNameLabel.text = [[model.introduce ht_htmlDecodeString] ht_attributedStringNeedDispatcher:nil].string;
	[self.headImageButton sd_setImageWithURL:[NSURL URLWithString:GmatResourse(model.teacherIamge)] forState:UIControlStateNormal placeholderImage:HTPLACEHOLDERIMAGE];
}

- (UIButton *)headImageButton {
	if (!_headImageButton) {
		_headImageButton = [[UIButton alloc] init];
		_headImageButton.layer.masksToBounds = true;
	}
	return _headImageButton;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.font = [UIFont ht_fontStyle:HTFontStyleTitleLarge];
		_titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
	}
	return _titleNameLabel;
}

- (UILabel *)detialNameLabel {
	if (!_detialNameLabel) {
		_detialNameLabel = [[UILabel alloc] init];
		_detialNameLabel.font = [UIFont ht_fontStyle:HTFontStyleDetailLarge];
		_detialNameLabel.textColor = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
		_detialNameLabel.numberOfLines = 2;
	}
	return _detialNameLabel;
}

- (UIButton *)inviteButton {
	if (!_inviteButton) {
		_inviteButton = [[UIButton alloc] init];
		[_inviteButton setTitle:@"预约" forState:UIControlStateNormal];
		_inviteButton.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleDetailLarge];
		_inviteButton.backgroundColor = [UIColor ht_colorStyle:HTColorStyleSpecialTheme];
		_inviteButton.layer.cornerRadius = 3;
		[_inviteButton setTitleColor:[UIColor ht_colorStyle:HTColorStyleBackground] forState:UIControlStateNormal];
	}
	return _inviteButton;
}

- (UIView *)lineView {
	if (!_lineView) {
		_lineView = [[UIView alloc] init];
		_lineView.backgroundColor = [UIColor ht_colorString:@"e6e6e6"];
	}
	return _lineView;
}

- (void)setFrame:(CGRect)frame {
	frame.origin.y += 7;
	frame.size.height -= 7;
	[super setFrame:frame];
}

@end
