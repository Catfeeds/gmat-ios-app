//
//  THTeacherDetailInfoCell.m
//  TingApp
//
//  Created by hublot on 16/8/24.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "THTeacherDetailInfoCell.h"
#import "UITableViewCell_HTSeparate.h"
#import "THCourseTogetherTeacherModel.h"
#import "NSString+HTString.h"
#import "NSAttributedString+HTAttributedString.h"
#import <NSObject+HTTableRowHeight.h>

@interface THTeacherDetailInfoCell ()

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UILabel *detailNameLabel;

@end

@implementation THTeacherDetailInfoCell

- (void)didMoveToSuperview {
	[self addSubview:self.titleNameLabel];
	[self addSubview:self.detailNameLabel];
	[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(0);
		make.right.mas_equalTo(0);
		make.left.mas_equalTo(0);
		make.height.mas_equalTo(35);
	}];
	[self.detailNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.titleNameLabel.mas_bottom).offset(15);
		make.left.mas_equalTo(15);
		make.right.mas_equalTo(- 15);
		make.bottom.mas_equalTo(self).offset(- 15);
	}];
	self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(THCourseTogetherTeacherModel *)model row:(NSInteger)row {
	NSMutableAttributedString *titleAttributedString = [[NSMutableAttributedString alloc] initWithString:@"个人简介"];
	self.titleNameLabel.numberOfLines = 0;
	NSMutableParagraphStyle *titleParagraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
	titleParagraphStyle.firstLineHeadIndent = 15;
	titleParagraphStyle.headIndent = 15;
	titleParagraphStyle.tailIndent = - 15;
	[titleAttributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],
										   NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTitle],
										   NSParagraphStyleAttributeName:titleParagraphStyle} range:NSMakeRange(0, titleAttributedString.length)];
	self.titleNameLabel.attributedText = titleAttributedString;
	self.detailNameLabel.attributedText = [[model.introduce ht_htmlDecodeString] ht_attributedStringNeedDispatcher:nil];
	self.detailNameLabel.ht_h = [self.detailNameLabel.attributedText ht_attributedStringHeightWithWidth:HTSCREENWIDTH - 30 textView:nil];
    
    CGFloat modelHeight = self.detailNameLabel.ht_h + 30 + 35;
    [model ht_setRowHeightNumber:@(modelHeight) forCellClass:self.class];
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.backgroundColor = [UIColor ht_colorStyle:HTColorStylePrimarySeparate];
	}
	return _titleNameLabel;
}

- (UILabel *)detailNameLabel {
	if (!_detailNameLabel) {
		_detailNameLabel = [[UILabel alloc] init];
		_detailNameLabel.font = [UIFont ht_fontStyle:HTFontStyleDetailLarge];
		_detailNameLabel.textColor = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
		_detailNameLabel.numberOfLines = 0;
	}
	return _detailNameLabel;
}

@end
