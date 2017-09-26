//
//  HTQuestionParseCell.m
//  GMat
//
//  Created by hublot on 2017/3/11.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTQuestionParseCell.h"
#import "HTQuestionParseModel.h"
#import "NSString+HTString.h"
#import "NSAttributedString+HTAttributedString.h"
#import "HTMineFontSizeController.h"
#import <NSObject+HTTableRowHeight.h>

@interface HTQuestionParseCell ()

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UILabel *detailNameLabel;

@end

@implementation HTQuestionParseCell

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor clearColor];
	[self addSubview:self.titleNameLabel];
	[self addSubview:self.detailNameLabel];
	[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self).offset(15);
		make.right.mas_equalTo(self).offset(- 15);
		make.top.mas_equalTo(self).offset(15);
	}];
	[self.detailNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self).offset(15);
		make.right.mas_equalTo(self).offset(- 15);
		make.top.mas_equalTo(self.titleNameLabel.mas_bottom).offset(5);
	}];
}

- (void)setModel:(HTQuestionParseModel *)model row:(NSInteger)row {
	
	CGFloat userFontZoomNumber = [HTMineFontSizeController fontZoomNumber];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"yyyy-MM-dd";
	NSString *parseSendDateString = [dateFormatter stringFromDate:model.parseSendDate];
	NSString *titleNameString = [NSString stringWithFormat:@"用户 %@ 于 %@ 提供解析 %ld :", model.parseSendOwner, parseSendDateString, row + 1];
	NSMutableAttributedString *titleNameAttributedString = [[NSMutableAttributedString alloc] initWithString:titleNameString];
	[titleNameAttributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14 * userFontZoomNumber],
											   NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStyleSecondaryTitle]} range:NSMakeRange(0, titleNameAttributedString.length)];
	[titleNameAttributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTheme]} range:NSMakeRange(3, model.parseSendOwner.length)];
	self.titleNameLabel.attributedText = titleNameAttributedString;
	
	NSMutableAttributedString *detailAttributedString = [model.parseContentAttributedString mutableCopy];
	[detailAttributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14 * userFontZoomNumber],
											NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTitle]} range:NSMakeRange(0, detailAttributedString.length)];
	self.detailNameLabel.attributedText = detailAttributedString;
	
	CGFloat questionParseSumHeight = 0;
	questionParseSumHeight += 15;
	CGFloat titleNameAttributedStringHeight = [self.titleNameLabel.attributedText ht_attributedStringHeightWithWidth:HTSCREENWIDTH - 60 textView:nil];
	[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.height.mas_equalTo(titleNameAttributedStringHeight);
	}];
	questionParseSumHeight += titleNameAttributedStringHeight;
	questionParseSumHeight += 5;
	questionParseSumHeight += [self.detailNameLabel.attributedText ht_attributedStringHeightWithWidth:HTSCREENWIDTH - 60 textView:nil];
	questionParseSumHeight += 15;
	
    CGFloat modelHeight = questionParseSumHeight;
    [model ht_setRowHeightNumber:@(modelHeight) forCellClass:self.class];
	
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.numberOfLines = 0;
	}
	return _titleNameLabel;
}

- (UILabel *)detailNameLabel {
	if (!_detailNameLabel) {
		_detailNameLabel = [[UILabel alloc] init];
		_detailNameLabel.numberOfLines = 0;
	}
	return _detailNameLabel;
}

@end
