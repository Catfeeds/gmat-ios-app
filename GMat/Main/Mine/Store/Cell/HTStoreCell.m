//
//  HTStoreCell.m
//  GMat
//
//  Created by hublot on 16/11/7.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTStoreCell.h"
#import <NSString+HTString.h>
#import <NSMutableAttributedString+HTMutableAttributedString.h>

@interface HTStoreCell ()

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UILabel *detailNameLabel;

@end

@implementation HTStoreCell

- (void)didMoveToSuperview {
	[self.contentView addSubview:self.titleNameLabel];
	[self.contentView addSubview:self.detailNameLabel];
	[self.titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.contentView).offset(15);
		make.top.mas_equalTo(self.contentView).offset(10);
		make.right.mas_equalTo(self.contentView).offset(- 10);
	}];
	[self.detailNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.contentView).offset(15);
		make.bottom.mas_equalTo(self.contentView).offset(- 10);
		make.right.mas_equalTo(self.contentView).offset(- 10);
	}];
}

- (void)setModel:(HTStoreModel *)model row:(NSInteger)row {
	self.titleNameLabel.text = [NSString stringWithFormat:@"%@-%@", model.section, model.questionid];
    NSMutableAttributedString *attributedString = [[[model.qtitle ht_htmlDecodeString] ht_attributedStringNeedDispatcher:nil] mutableCopy];
    [attributedString ht_clearBreakLineMaxAllowContinueCount:0];
	self.detailNameLabel.text = attributedString.string;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.font = [UIFont systemFontOfSize:15];
		_titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
	}
	return _titleNameLabel;
}

- (UILabel *)detailNameLabel {
	if (!_detailNameLabel) {
		_detailNameLabel = [[UILabel alloc] init];
		_detailNameLabel.font = [UIFont systemFontOfSize:14];
		_detailNameLabel.textColor = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
	}
	return _detailNameLabel;
}


@end
