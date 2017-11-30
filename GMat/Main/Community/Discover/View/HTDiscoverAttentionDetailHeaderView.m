//
//  HTDiscoverAttentionDetailHeaderView.m
//  GMat
//
//  Created by hublot on 2017/7/5.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTDiscoverAttentionDetailHeaderView.h"
#import "HTDiscoverAttentionModel.h"
#import "HTImageTextView.h"
#import <UIButton+HTButtonCategory.h>
#import "HTWebController.h"

@interface HTDiscoverAttentionDetailHeaderView ()

@property (nonatomic, strong) UITableView *superForHeaderTableView;

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UIButton *detailLookButton;

@property (nonatomic, strong) UIButton *sendTimeButton;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) HTImageTextView *contentTextView;

@property (nonatomic, strong) HTDiscoverAttentionModel *model;

@end

@implementation HTDiscoverAttentionDetailHeaderView

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor whiteColor];
	[self addSubview:self.titleNameLabel];
	[self addSubview:self.detailLookButton];
	[self addSubview:self.sendTimeButton];
	[self addSubview:self.lineView];
	[self addSubview:self.contentTextView];
	[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(15);
		make.left.mas_equalTo(15);
		make.right.mas_equalTo(- 15);
	}];
	[self.detailLookButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.titleNameLabel.mas_bottom).offset(15);
		make.left.mas_equalTo(self.titleNameLabel);
	}];
	[self.sendTimeButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.centerY.mas_equalTo(self.detailLookButton);
		make.left.mas_equalTo(self.detailLookButton.mas_right).offset(20);
	}];
	[self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.titleNameLabel);
		make.right.mas_equalTo(self.titleNameLabel);
		make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
		make.top.mas_equalTo(self.detailLookButton.mas_bottom).offset(15);
	}];
	[self.contentTextView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.titleNameLabel);
		make.right.mas_equalTo(self.titleNameLabel);
		make.top.mas_equalTo(self.lineView.mas_bottom).offset(10);
		make.bottom.mas_equalTo(- 10);
	}];
}

- (void)setModel:(HTDiscoverAttentionModel *)model tableView:(UITableView *)tableView {
	_model = model;
	__weak typeof(self) weakSelf = self;
	self.superForHeaderTableView = tableView;
	self.titleNameLabel.font = [[UIFont ht_fontStyle:HTFontStyleHeadSmall] ht_userSizeFont];
	self.titleNameLabel.text = model.contenttitle;
	[self.detailLookButton setTitle:model.views forState:UIControlStateNormal];
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = @"yyyy-MM-dd";
	NSString *sentTimeString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:model.contentinputtime.integerValue]];
	
	[self.sendTimeButton setTitle:[NSString stringWithFormat:@"发布于 %@", sentTimeString] forState:UIControlStateNormal];
	
	NSString *contentString = model.contenttext;
	
	NSMutableAttributedString *attributedString = [[contentString ht_handleFillPlaceHolderImageWithMaxWidth:HTSCREENWIDTH - 30 placeholderImage:HTPLACEHOLDERIMAGE] mutableCopy];
	
	[attributedString ht_EnumerateAttribute:NSFontAttributeName usingBlock:^(UIFont *font, NSRange range, BOOL *stop) {
		if (font.pointSize < 14) {
			UIFont *resetFont = [UIFont fontWithDescriptor:font.fontDescriptor size:14];
			[attributedString addAttributes:@{NSFontAttributeName:resetFont} range:range];
		}
	}];
    
    [attributedString ht_clearBreakLineMaxAllowContinueCount:2];
    [attributedString ht_clearPrefixBreakLine];
    [attributedString ht_clearSuffixBreakLine];
	
	[self.contentTextView setAttributedString:attributedString textViewMaxWidth:HTSCREENWIDTH - 30 appendImageBaseURLBlock:^NSString *(UITextView *textView, NSString *imagePath) {
		if (![imagePath containsString:@"http"]) {
			return GmatResourse(imagePath);
		}
		return imagePath;
	} reloadHeightBlock:^(UITextView *textView, CGFloat contentHeight) {
		[weakSelf computeQuestionViewHeightWithContentTextViewHeight:contentHeight];
	} didSelectedURLBlock:^(UITextView *textView, NSURL *URL, NSString *titleName) {
		HTWebController *webController = [[HTWebController alloc] initWithURL:URL];
		[weakSelf.ht_controller.navigationController pushViewController:webController animated:true];
	}];
}

- (void)computeQuestionViewHeightWithContentTextViewHeight:(CGFloat)textViewHeight {
	CGFloat contentHeight = textViewHeight;
	self.contentTextView.ht_h = contentHeight;
	self.ht_h = self.contentTextView.ht_h + 20 + 90;
	self.superForHeaderTableView.tableHeaderView = self;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
	}
	return _titleNameLabel;
}

- (UIButton *)detailLookButton {
	if (!_detailLookButton) {
		_detailLookButton = [[UIButton alloc] init];
		[_detailLookButton setImage:[[UIImage imageNamed:@"Toeflxiaoxi"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
		[_detailLookButton setTitleColor:[UIColor ht_colorStyle:HTColorStyleSecondaryTitle] forState:UIControlStateNormal];
		_detailLookButton.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleDetailSmall];
		[_detailLookButton ht_makeEdgeWithDirection:HTButtonEdgeDirectionHorizontal imageViewToTitleLabelSpeceOffset:3];
	}
	return _detailLookButton;
}

- (UIButton *)sendTimeButton {
	if (!_sendTimeButton) {
		_sendTimeButton = [[UIButton alloc] init];
		_sendTimeButton.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleDetailSmall];
		[_sendTimeButton setTitleColor:[UIColor ht_colorStyle:HTColorStyleSecondaryTitle] forState:UIControlStateNormal];
	}
	return _sendTimeButton;
}

- (UIView *)lineView {
	if (!_lineView) {
		_lineView = [[UIView alloc] init];
		_lineView.backgroundColor = [UIColor ht_colorString:@"e6e6e6"];
	}
	return _lineView;
}

- (HTImageTextView *)contentTextView {
	if (!_contentTextView) {
		_contentTextView = [[HTImageTextView alloc] init];
		_contentTextView.font = [UIFont ht_fontStyle:HTFontStyleDetailLarge];
		_contentTextView.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
	}
	return _contentTextView;
}

@end
