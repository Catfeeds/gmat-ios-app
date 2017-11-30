//
//  HTDiscussReplyCell.m
//  GMat
//
//  Created by hublot on 17/8/24.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTDiscussReplyCell.h"
#import "HTDiscussModel.h"
#import <NSObject+HTTableRowHeight.h>
#import <NSAttributedString+HTAttributedString.h>

@interface HTDiscussReplyCell ()

@property (nonatomic, strong) UILabel *titleNameLabel;

@end

@implementation HTDiscussReplyCell

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.titleNameLabel];
    [self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(6, 15, 6, 15));
    }];
}

- (void)setModel:(HTDiscussReplyModel *)model row:(NSInteger)row {
    CGFloat font = 13;
    NSDictionary *normalDictionary = @{NSFontAttributeName:[UIFont systemFontOfSize:font],
                                       NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTitle]};
    NSDictionary *selectedDictionary = @{NSFontAttributeName:[UIFont systemFontOfSize:font],
                                         NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTheme]};
    NSString *nameString = HTPlaceholderString(model.nickname, model.username);
	NSString *nameAppend = [NSString stringWithFormat:@"%@: ", nameString];
	NSMutableAttributedString *attributedString;
	NSAttributedString *appendAttributedString;
	
	attributedString = [[[NSAttributedString alloc] initWithString:nameAppend attributes:selectedDictionary] mutableCopy];
	appendAttributedString = [[NSAttributedString alloc] initWithString:model.content attributes:normalDictionary];
	[attributedString appendAttributedString:appendAttributedString];
    self.titleNameLabel.attributedText = attributedString;
    
    CGFloat modelHeight = [self.titleNameLabel.attributedText ht_attributedStringHeightWithWidth:HTSCREENWIDTH - 30 textView:nil];
	modelHeight += 12;
    [model ht_setRowHeightNumber:@(modelHeight) forCellClass:self.class];
}

- (UILabel *)titleNameLabel {
    if (!_titleNameLabel) {
        _titleNameLabel = [[UILabel alloc] init];
        _titleNameLabel.numberOfLines = 0;
    }
    return _titleNameLabel;
}


@end
