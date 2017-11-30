//
//  HTCourseTitleDetailCell.m
//  GMat
//
//  Created by hublot on 16/10/14.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTCourseTitleDetailCell.h"
#import "HTCourseTitleDetailModel.h"
#import "NSString+HTString.h"
#import "NSAttributedString+HTAttributedString.h"
#import "TTTAttributedLabel.h"
#import <NSObject+HTTableRowHeight.h>


@interface HTCourseTitleDetailCell () <TTTAttributedLabelDelegate>

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) TTTAttributedLabel *detailNameLabel;

@end

@implementation HTCourseTitleDetailCell

- (void)didMoveToSuperview {
	[self addSubview:self.titleNameLabel];
	[self addSubview:self.detailNameLabel];
	[self.titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self).mas_offset(15);
		make.top.mas_equalTo(self);
		make.height.mas_equalTo(40);
		make.right.mas_equalTo(self).mas_offset(- 15);
	}];
	[self.detailNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.titleNameLabel.mas_bottom).offset(15);
		make.left.mas_equalTo(self.titleNameLabel);
		make.right.mas_equalTo(self).mas_offset(- 15);
        make.bottom.mas_equalTo(self).offset(- 15);
	}];
}

- (void)setModel:(HTCourseTitleDetailModel *)model row:(NSInteger)row {
	self.titleNameLabel.text = model.titleName;
	NSString *clearSpanPageString = @"<p><span style=\"color: #000000; font-family: 微软雅黑,Microsoft YaHei; font-size: 14px;\"><br/></span></p>";
	NSString *clearBrPageString = @"<br/>";
	NSString *clearDetailString = [model.detailName ht_htmlDecodeString];
	clearDetailString = [clearDetailString stringByReplacingOccurrencesOfString:clearSpanPageString withString:@""];
	clearSpanPageString = [clearSpanPageString stringByReplacingOccurrencesOfString:clearBrPageString withString:@""];
    [self.detailNameLabel setText:[clearDetailString ht_attributedStringNeedDispatcher:nil]];
    CGFloat modelHeight = [self.detailNameLabel.attributedText ht_attributedStringHeightWithWidth:HTSCREENWIDTH - 30 textView:nil] + 40 + 30;
    [model ht_setRowHeightNumber:@(modelHeight) forCellClass:self.class];
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTheme];
		_titleNameLabel.font = [UIFont systemFontOfSize:15];
	}
	return _titleNameLabel;
}

- (UILabel *)detailNameLabel {
	if (!_detailNameLabel) {
		_detailNameLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
		_detailNameLabel.textColor = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
		_detailNameLabel.font = [UIFont systemFontOfSize:12];
		_detailNameLabel.numberOfLines = 0;
        _detailNameLabel.delegate = self;
        _detailNameLabel.enabledTextCheckingTypes = NSTextCheckingTypePhoneNumber | NSTextCheckingTypeAddress | NSTextCheckingTypeLink;
	}
	return _detailNameLabel;
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url{
    [HTAlert title:@"访问外部链接" sureAction:^{
        [[UIApplication sharedApplication] openURL:url];
    }];
}

@end
