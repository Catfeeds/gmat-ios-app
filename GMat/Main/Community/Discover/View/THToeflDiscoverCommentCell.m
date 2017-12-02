//
//  THToeflDiscoverCommentCell.m
//  TingApp
//
//  Created by hublot on 16/9/7.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "THToeflDiscoverCommentCell.h"
#import "THToeflDiscoverModel.h"
#import "UITableView+HTSeparate.h"
#import <NSString+HTString.h>
#import <UIButton+HTButtonCategory.h>
#import <NSObject+HTTableRowHeight.h>

@interface THToeflDiscoverCommentCell ()

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *nicknameLabel;

@property (nonatomic, strong) UILabel *sendTimeLabel;

@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation THToeflDiscoverCommentCell

- (void)didMoveToSuperview {
	[self addSubview:self.headImageView];
	[self addSubview:self.nicknameLabel];
	[self addSubview:self.sendTimeLabel];
	[self addSubview:self.messageLabel];
	[self.headImageView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(20);
		make.top.mas_equalTo(20);
		make.width.height.mas_equalTo(40);
	}];
	[self.nicknameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.headImageView.mas_right).offset(10);
		make.top.mas_equalTo(self.headImageView);
		make.right.mas_equalTo(- 15);
	}];
	[self.sendTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.nicknameLabel);
		make.top.mas_equalTo(self.nicknameLabel.mas_bottom).offset(5);
		make.right.mas_equalTo(- 15);
	}];
	[self.messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.nicknameLabel);
		make.right.mas_equalTo(- 15);
		make.top.mas_equalTo(self.sendTimeLabel.mas_bottom).offset(15);
	}];
}

- (void)setModel:(THDiscoverReply *)model row:(NSInteger)row {
	self.nicknameLabel.text = HTPlaceholderString(model.nickname, model.username);
	NSDate *sendDate = [NSDate dateWithTimeIntervalSince1970:model.createTime.integerValue];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = @"yyyy-MM-dd";
	NSString *dateString = [formatter stringFromDate:sendDate];
	self.sendTimeLabel.text = dateString;
	[self.headImageView sd_setImageWithURL:[NSURL URLWithString:GmatResourse(model.uid)] placeholderImage:HTPLACEHOLDERIMAGE];
	self.messageLabel.text = model.content;
    CGFloat height = [self.messageLabel.text ht_stringHeightWithWidth:HTSCREENWIDTH - 15 - 70 - 15 font:self.messageLabel.font textView:nil];
	self.messageLabel.ht_h = height;
    CGFloat modelHeigth = self.messageLabel.ht_h + 90;
    [model ht_setRowHeightNumber:@(modelHeigth) forCellClass:self.class];
}

- (UIImageView *)headImageView {
	if (!_headImageView) {
		_headImageView = [[UIImageView alloc] init];
		_headImageView.layer.cornerRadius = 40 / 2;
		_headImageView.layer.masksToBounds = true;
	}
	return _headImageView;
}

- (UILabel *)nicknameLabel {
	if (!_nicknameLabel) {
		_nicknameLabel = [[UILabel alloc] init];
		_nicknameLabel.font = [UIFont systemFontOfSize:14];
		_nicknameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
	}
	return _nicknameLabel;
}

- (UILabel *)sendTimeLabel {
	if (!_sendTimeLabel) {
		_sendTimeLabel = [[UILabel alloc] init];
		_sendTimeLabel.font = [UIFont systemFontOfSize:12];
		_sendTimeLabel.textColor = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
	}
	return _sendTimeLabel;
}

- (UILabel *)messageLabel {
	if (!_messageLabel) {
		_messageLabel = [[UILabel alloc] init];
		_messageLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_messageLabel.font = [[UIFont systemFontOfSize:14] ht_userSizeFont];
	}
	return _messageLabel;
}

- (void)setFrame:(CGRect)frame {
	frame.origin.y += 1;
	frame.size.height -= 1;
	[super setFrame:frame];
}

@end
