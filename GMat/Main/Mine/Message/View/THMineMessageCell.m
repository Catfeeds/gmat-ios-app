//
//  THMineMessageCell.m
//  TingApp
//
//  Created by hublot on 16/8/29.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "THMineMessageCell.h"
#import "HTMessageModel.h"
#import <NSAttributedString+HTAttributedString.h>
#import <NSObject+HTTableRowHeight.h>

@interface THMineMessageCell ()

@property (nonatomic, strong) UILabel *titleTimeLabel;

@property (nonatomic, strong) UIView *orangePointView;

@property (nonatomic, strong) UIButton *detailMessageButton;

@end

@implementation THMineMessageCell

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor clearColor];
	[self addSubview:self.titleTimeLabel];
	[self addSubview:self.detailMessageButton];
	[self addSubview:self.orangePointView];
	
	[self.titleTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.centerY.mas_equalTo(self.orangePointView);
		make.right.mas_equalTo(self.orangePointView.mas_left).offset(- 10);
	}];
	
	[self.orangePointView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.centerX.mas_equalTo(self.mas_left).offset(HTMineMessagePointLineLeftDistance);
		make.top.mas_equalTo(20);
		make.width.mas_equalTo(5);
		make.height.mas_equalTo(5);
	}];
	
	[self.detailMessageButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.orangePointView).offset(- 10);
		make.left.mas_equalTo(self.orangePointView.mas_right).offset(10);
		make.right.mas_equalTo(self).offset(- 10);
		make.bottom.mas_equalTo(self).offset(- 10);
	}];
	
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.orangePointView.layer.cornerRadius = self.orangePointView.bounds.size.width / 2;
}

- (void)setModel:(HTMessageModel *)model row:(NSInteger)row {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"MM月dd日\nHH:mm:ss";
	NSString *dateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:model.time.integerValue]];
	NSMutableAttributedString *timeAttributedString = [[NSMutableAttributedString alloc] initWithString:dateString attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:13]}];
	[timeAttributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStyleNormalTheme]} range:NSMakeRange(0, 6)];
	self.titleTimeLabel.attributedText = timeAttributedString;
	NSMutableAttributedString *messageAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: %@", model.title, model.content] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
	[self.detailMessageButton setAttributedTitle:messageAttributedString forState:UIControlStateNormal];
	
	CGFloat buttonLabelWidth = HTSCREENWIDTH - HTMineMessagePointLineLeftDistance - 10 - 10 - self.detailMessageButton.contentEdgeInsets.left - self.detailMessageButton.contentEdgeInsets.right;
    
    CGFloat modelHeight = [messageAttributedString ht_attributedStringHeightWithWidth:buttonLabelWidth textView:nil] + self.detailMessageButton.contentEdgeInsets.top + self.detailMessageButton.contentEdgeInsets.bottom + 10 + 10;
    [model ht_setRowHeightNumber:@(modelHeight) forCellClass:self.class];    
}

- (UILabel *)titleTimeLabel {
	if (!_titleTimeLabel) {
		_titleTimeLabel = [[UILabel alloc] init];
		_titleTimeLabel.textAlignment = NSTextAlignmentRight;
		_titleTimeLabel.numberOfLines = 0;
	}
	return _titleTimeLabel;
}

- (UIView *)orangePointView {
	if (!_orangePointView) {
		_orangePointView = [UIView new];
		_orangePointView.backgroundColor = [UIColor ht_colorStyle:HTColorStylePrimaryTheme];
	}
	return _orangePointView;
}

- (UIButton *)detailMessageButton {
	if (!_detailMessageButton) {
		_detailMessageButton = [[UIButton alloc] init];
		_detailMessageButton.titleLabel.numberOfLines = 0;
		_detailMessageButton.contentEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
		_detailMessageButton.backgroundColor = [UIColor whiteColor];
		_detailMessageButton.layer.cornerRadius = 3;
		_detailMessageButton.layer.masksToBounds = true;
	}
	return _detailMessageButton;
}

@end
