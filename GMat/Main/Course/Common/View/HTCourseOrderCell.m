//
//  HTCourseOrderCell.m
//  GMat
//
//  Created by hublot on 2016/11/16.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTCourseOrderCell.h"
#import "HTCourseOrderModel.h"

@interface HTCourseOrderCell ()

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UILabel *courseStartLabel;

@property (nonatomic, strong) UILabel *orderIdLabel;

@end

@implementation HTCourseOrderCell

- (void)didMoveToSuperview {
	[self.contentView addSubview:self.headImageView];
	[self.contentView addSubview:self.titleNameLabel];
	[self.contentView addSubview:self.courseStartLabel];
	[self.contentView addSubview:self.orderIdLabel];
	[self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self).offset(15);
		make.bottom.mas_equalTo(self).offset(- 15);
		make.left.mas_equalTo(self).offset(15);
		make.width.mas_equalTo(self.headImageView.mas_height).multipliedBy(4 / 3.0);
	}];
	[self.titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.headImageView.mas_right).offset(10);
		make.top.mas_equalTo(self.headImageView);
		make.right.mas_equalTo(self).offset(- 10);
	}];
	[self.courseStartLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.mas_equalTo(self.headImageView);
		make.left.mas_equalTo(self.titleNameLabel);
		make.right.mas_equalTo(self).offset(- 10);
	}];
	[self.orderIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.titleNameLabel);
		make.bottom.mas_equalTo(self.headImageView);
		make.right.mas_equalTo(self).offset(- 10);
	}];
}

- (void)setModel:(HTCourseOrderModel *)model row:(NSInteger)row {
	[self.headImageView sd_setImageWithURL:[NSURL URLWithString:GmatResourse(model.data.contentthumb)] placeholderImage:HTPLACEHOLDERIMAGE];
	self.titleNameLabel.text = model.data.contenttitle;
	self.courseStartLabel.text = model.data.time;
	self.orderIdLabel.text = [NSString stringWithFormat:@"订单编号: %@", model.order_id];
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
		_titleNameLabel.font = [UIFont ht_fontStyle:HTFontStyleTitleSmall];
		_titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
	}
	return _titleNameLabel;
}

- (UILabel *)courseStartLabel {
	if (!_courseStartLabel) {
		_courseStartLabel = [[UILabel alloc] init];
		_courseStartLabel.font = [UIFont ht_fontStyle:HTFontStyleDetailLarge];
		_courseStartLabel.textColor = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
	}
	return _courseStartLabel;
}

- (UILabel *)orderIdLabel {
	if (!_orderIdLabel) {
		_orderIdLabel = [[UILabel alloc] init];
		_orderIdLabel.font = [UIFont ht_fontStyle:HTFontStyleDetailLarge];
		_orderIdLabel.textColor = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
	}
	return _orderIdLabel;
}

@end
