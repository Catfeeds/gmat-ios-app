//
//  HTCourseDetailTextCell.m
//  GMat
//
//  Created by hublot on 2017/5/11.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTCourseDetailTextCell.h"
#import "TTTAttributedLabel.h"
#import "HTWebController.h"
#import "NSAttributedString+HTAttributedString.h"
#import <NSMutableAttributedString+HTMutableAttributedString.h>
#import "NSString+HTString.h"
#import <NSObject+HTTableRowHeight.h>

@interface HTCourseDetailTextCell () <TTTAttributedLabelDelegate>

@property (nonatomic, strong) TTTAttributedLabel *titleNameLabel;

@end

@implementation HTCourseDetailTextCell

- (void)didMoveToSuperview {
	[self addSubview:self.titleNameLabel];
	[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(self).mas_offset(UIEdgeInsetsMake(10, 10, 10, 10));
	}];
}

- (void)setModel:(NSString *)model row:(NSInteger)row {
	
	NSString *contentString = model;
	
	NSMutableAttributedString *attributedString = [[[contentString ht_htmlDecodeString] ht_attributedStringNeedDispatcher:nil] mutableCopy];
    [attributedString ht_clearBreakLineMaxAllowContinueCount:2];
    [attributedString ht_clearPrefixBreakLine];
    [attributedString ht_clearSuffixBreakLine];
		
	self.titleNameLabel.text = attributedString;
	CGFloat modelHeight = [TTTAttributedLabel sizeThatFitsAttributedString:attributedString
														   withConstraints:CGSizeMake(HTSCREENWIDTH - 20, MAXFLOAT)
													limitedToNumberOfLines:0].height + 20;
    [model ht_setRowHeightNumber:@(modelHeight) forCellClass:self.class];
}

- (TTTAttributedLabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
		_titleNameLabel.numberOfLines = 0;
		_titleNameLabel.delegate = self;
	}
	return _titleNameLabel;
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url {
	HTWebController *webController = [[HTWebController alloc] initWithURL:url];
	[self.ht_controller.navigationController pushViewController:webController animated:true];
}

@end
