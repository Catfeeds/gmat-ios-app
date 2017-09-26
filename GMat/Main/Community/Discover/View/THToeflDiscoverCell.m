//
//  THToeflDiscoverCell.m
//  TingApp
//
//  Created by hublot on 16/8/30.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "THToeflDiscoverCell.h"
#import "THToeflDiscoverModel.h"
#import <UIButton+HTButtonCategory.h>
#import <NSObject+HTTableRowHeight.h>

@interface THToeflDiscoverCell ()

@property (nonatomic, strong) UIButton *headImageButton;

@property (nonatomic, strong) UILabel *usernameLabel;

@property (nonatomic, strong) UIImageView *backImageView;

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UILabel *detailTimeLabel;

@property (nonatomic, strong) UIButton *rightLookButton;

@property (nonatomic, strong) UIView *whiteSpaceView;

@end

@implementation THToeflDiscoverCell

- (void)didMoveToSuperview {
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	[self addSubview:self.backImageView];
	[self addSubview:self.whiteSpaceView];
	[self addSubview:self.headImageButton];
	[self addSubview:self.usernameLabel];
	[self addSubview:self.titleNameLabel];
	[self addSubview:self.detailTimeLabel];
	[self addSubview:self.rightLookButton];
	
	[self.headImageButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(20);
		make.top.mas_equalTo(10);
		make.width.height.mas_equalTo(40);
	}];
	[self.backImageView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.right.mas_equalTo(self);
		make.height.mas_equalTo(200);
		make.top.mas_equalTo(self.headImageButton.mas_bottom).offset(- 15);
	}];
	[self.usernameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.headImageButton.mas_right).offset(10);
		make.bottom.mas_equalTo(self.backImageView.mas_top).offset(- 5);
		make.right.mas_equalTo(self).offset(- 10);
	}];
	[self.whiteSpaceView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(self.headImageButton.mas_width).offset(2);
		make.centerX.mas_equalTo(self.headImageButton);
		make.centerY.mas_equalTo(self.headImageButton);
	}];
	[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(15);
		make.top.mas_equalTo(self.backImageView.mas_bottom).offset(10);
		make.right.mas_equalTo(- 15);
	}];
	[self.detailTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.titleNameLabel);
		make.top.mas_equalTo(self.titleNameLabel.mas_bottom).offset(10);
	}];
	[self.rightLookButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.right.mas_equalTo(- 15);
		make.centerY.mas_equalTo(self.detailTimeLabel);
		make.left.mas_greaterThanOrEqualTo(self.detailTimeLabel.mas_right).offset(15).priority(900);
	}];
}

- (void)setModel:(THToeflDiscoverModel *)model row:(NSInteger)row {
	self.titleNameLabel.font = [[UIFont ht_fontStyle:HTFontStyleTitleLarge] ht_userSizeFont];
	[self.backImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"ToeflRecommendPlaceholder"]];
	[self.headImageButton setBackgroundImage:HTPLACEHOLDERIMAGE forState:UIControlStateNormal];
	self.usernameLabel.text = HTPlaceholderString(model.nickname, model.username);
	self.titleNameLabel.text = model.title;
	self.detailTimeLabel.text = [NSString stringWithFormat:@"发布于 %@", model.dateTime];
	[self.rightLookButton setTitle:model.viewCount forState:UIControlStateNormal];
	CGFloat modelHeight = 90 + HTADAPT568(20) + 200;
	[model ht_setRowHeightNumber:@(modelHeight) forCellClass:self.class];
}

- (UIButton *)headImageButton {
	if (!_headImageButton) {
		_headImageButton = [[UIButton alloc] init];
		_headImageButton.layer.cornerRadius = 40 / 2;
		_headImageButton.layer.masksToBounds = true;
	}
	return _headImageButton;
}

- (UILabel *)usernameLabel {
	if (!_usernameLabel) {
		_usernameLabel = [[UILabel alloc] init];
		_usernameLabel.textColor = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
		_usernameLabel.font = [UIFont systemFontOfSize:13];
	}
	return _usernameLabel;
}

- (UIImageView *)backImageView {
	if (!_backImageView) {
		_backImageView = [[UIImageView alloc] init];
		_backImageView.layer.masksToBounds = true;
	}
	return _backImageView;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
	}
	return _titleNameLabel;
}

- (UILabel *)detailTimeLabel {
	if (!_detailTimeLabel) {
		_detailTimeLabel = [[UILabel alloc] init];
		_detailTimeLabel.textColor = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
		_detailTimeLabel.font = [UIFont systemFontOfSize:13];
		[_detailTimeLabel setContentHuggingPriority:100 forAxis:UILayoutConstraintAxisHorizontal];
		[_detailTimeLabel setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisHorizontal];
	}
	return _detailTimeLabel;
}

- (UIButton *)rightLookButton {
	if (!_rightLookButton) {
		_rightLookButton = [[UIButton alloc] init];
		[_rightLookButton setImage:[UIImage imageNamed:@"Toeflxiaoxi"] forState:UIControlStateNormal];
		[_rightLookButton setTitleColor:[UIColor ht_colorStyle:HTColorStyleSecondaryTitle] forState:UIControlStateNormal];
		_rightLookButton.titleLabel.font = [UIFont systemFontOfSize:13];
		[_rightLookButton ht_makeEdgeWithDirection:HTButtonEdgeDirectionHorizontal imageViewToTitleLabelSpeceOffset:3];
	}
	return _rightLookButton;
}

- (UIView *)whiteSpaceView {
	if (!_whiteSpaceView) {
		_whiteSpaceView = [[UIView alloc] init];
		_whiteSpaceView.backgroundColor = [UIColor whiteColor];
		_whiteSpaceView.layer.cornerRadius = self.headImageButton.layer.cornerRadius + 1;
	}
	return _whiteSpaceView;
}

- (void)setFrame:(CGRect)frame {
	frame.origin.y += 10;
	frame.size.height -= 10;
	[super setFrame:frame];
}

@end
