//
//  HTReportLineTableCell.m
//  GMat
//
//  Created by hublot on 16/11/30.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTReportLineTableCell.h"

@interface HTReportLineTableCell ()

@property (nonatomic, strong) UILabel *leftLabel;

@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) UIView *blueLineView;

@end

@implementation HTReportLineTableCell

- (void)didMoveToSuperview {
	[self addSubview:self.leftLabel];
	[self addSubview:self.rightLabel];
	[self addSubview:self.blueLineView];
	[self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.bottom.mas_equalTo(self);
		make.left.mas_equalTo(15);
	}];
	[self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.bottom.mas_equalTo(self);
		make.right.mas_equalTo(- 15);
	}];
	[self.blueLineView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(150);
		make.height.mas_equalTo(20);
		make.centerY.mas_equalTo(self);
	}];
}

- (void)setModel:(NSDictionary *)model row:(NSInteger)row {
	[model enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
		self.leftLabel.text = key;
		self.rightLabel.text = [NSString stringWithFormat:@"正确率:%.0lf%%", [obj floatValue] * 100];
		[self.blueLineView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.width.mas_equalTo((HTSCREENWIDTH - 250) * [obj floatValue]);
		}];
		*stop = true;
	}];
}

- (UILabel *)leftLabel {
	if (!_leftLabel) {
		_leftLabel = [[UILabel alloc] init];
		_leftLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_leftLabel.font = [UIFont systemFontOfSize:14];
		_leftLabel.textAlignment = NSTextAlignmentLeft;
	}
	return _leftLabel;
}

- (UILabel *)rightLabel {
	if (!_rightLabel) {
		_rightLabel = [[UILabel alloc] init];
		_rightLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_rightLabel.font = [UIFont systemFontOfSize:14];
		_leftLabel.textAlignment = NSTextAlignmentRight;
	}
	return _rightLabel;
}

- (UIView *)blueLineView {
	if (!_blueLineView) {
		_blueLineView = [[UIView alloc] init];
		_blueLineView.backgroundColor = [UIColor ht_colorStyle:HTColorStylePrimaryTheme];
	}
	return _blueLineView;
}


@end
