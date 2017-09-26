//
//  HTQuestionMockStartSum.m
//  GMat
//
//  Created by hublot on 2016/11/29.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTQuestionMockStartSum.h"

@interface HTQuestionMockStartSum ()

@property (nonatomic, strong) UILabel *headNameLabel;

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UILabel *detailNameLabel;

@end

@implementation HTQuestionMockStartSum

- (void)didMoveToSuperview {
	[self addSubview:self.headNameLabel];
	[self addSubview:self.titleNameLabel];
	[self addSubview:self.detailNameLabel];
	self.layer.borderColor = [UIColor ht_colorStyle:HTColorStylePrimaryTheme].CGColor;
	self.layer.borderWidth = 1;
	[self.headNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.left.right.mas_equalTo(self);
		make.height.mas_equalTo(self).multipliedBy(0.4);
	}];
	[self.titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.mas_equalTo(self);
		make.height.mas_equalTo(self).multipliedBy(0.3);
		make.top.mas_equalTo(self.headNameLabel.mas_bottom);
	}];
	[self.detailNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.mas_equalTo(self);
		make.height.mas_equalTo(self).multipliedBy(0.3);
		make.top.mas_equalTo(self.titleNameLabel.mas_bottom);
	}];
}

- (void)setHeadString:(NSString *)headString titleString:(NSString *)titleString detailString:(NSString *)detailString {
	self.headNameLabel.text = headString;
	self.titleNameLabel.text = titleString;
	self.detailNameLabel.text = detailString;
}

- (UILabel *)headNameLabel {
	if (!_headNameLabel) {
		_headNameLabel = [[UILabel alloc] init];
		_headNameLabel.textAlignment =  NSTextAlignmentCenter;
		_headNameLabel.font = [UIFont ht_fontStyle:HTFontStyleTitleLarge];
		_headNameLabel.textColor = [UIColor whiteColor];
		_headNameLabel.backgroundColor = [UIColor ht_colorStyle:HTColorStylePrimaryTheme];
		_headNameLabel.text = @"Quant部分";
	}
	return _headNameLabel;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.textAlignment = NSTextAlignmentCenter;
		_titleNameLabel.font = [UIFont ht_fontStyle:HTFontStyleDetailLarge];
		_titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
		_titleNameLabel.text = @"共计37题";
	}
	return _titleNameLabel;
}

- (UILabel *)detailNameLabel {
	if (!_detailNameLabel) {
		_detailNameLabel = [[UILabel alloc] init];
		_detailNameLabel.textAlignment = NSTextAlignmentCenter;
		_detailNameLabel.font = [UIFont ht_fontStyle:HTFontStyleDetailLarge];
		_detailNameLabel.textColor = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
		_detailNameLabel.text = @"限时75分钟";
	}
	return _detailNameLabel;
}


@end
