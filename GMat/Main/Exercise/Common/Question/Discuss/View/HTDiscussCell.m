//
//  HTDiscussCell.m
//  GMat
//
//  Created by hublot on 2017/8/23.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTDiscussCell.h"
#import "HTDiscussModel.h"
#import <NSObject+HTTableRowHeight.h>
#import <NSString+HTString.h>
#import "HTDiscussReplyCell.h"
#import <UITableView+HTSeparate.h>
#import "HTCommunityReplyKeyBoardView.h"
#import "HTDiscussController.h"
#import <UIScrollView+HTRefresh.h>

@interface HTDiscussCell ()

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *nicknameLabel;

@property (nonatomic, strong) UILabel *sendTimeLabel;

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UIView *separatorLineView;

@property (nonatomic, strong) UITableView *replyTableView;

@end

@implementation HTDiscussCell

- (void)didMoveToSuperview {
	[self addSubview:self.headImageView];
	[self addSubview:self.nicknameLabel];
	[self addSubview:self.sendTimeLabel];
	[self addSubview:self.titleNameLabel];
    [self addSubview:self.separatorLineView];
    [self addSubview:self.replyTableView];
	[self.headImageView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(15);
		make.top.mas_equalTo(15);
		make.width.height.mas_equalTo(40);
	}];
	[self.nicknameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.headImageView).offset(2);
		make.left.mas_equalTo(self.headImageView.mas_right).offset(15);
		make.right.mas_equalTo(- 15);
	}];
	[self.sendTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.bottom.mas_equalTo(self.headImageView).offset(- 2);
		make.left.right.mas_equalTo(self.nicknameLabel);
	}];
	[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.headImageView);
		make.right.mas_equalTo(- 15);
		make.top.mas_equalTo(self.headImageView.mas_bottom).offset(15);
	}];
    [self.separatorLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.titleNameLabel.mas_bottom).offset(15);
        make.height.mas_equalTo( 1 / [UIScreen mainScreen].scale);
    }];
    [self.replyTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.separatorLineView.mas_bottom).offset(0);
        make.left.right.mas_equalTo(self);
    }];
}

- (void)setModel:(HTDiscussModel *)model row:(NSInteger)row {
	[self.headImageView sd_setImageWithURL:[NSURL URLWithString:GmatResourse(model.photo)] placeholderImage:HTPLACEHOLDERIMAGE];
	self.nicknameLabel.text = HTPlaceholderString(model.nickname, model.username);
	self.sendTimeLabel.text = model.c_time;
	self.titleNameLabel.text = model.content;

	CGFloat modelHeight = 15 + 45 + 15;
	CGFloat contentHeight = [self.titleNameLabel.text ht_stringHeightWithWidth:HTSCREENWIDTH - 30 font:self.titleNameLabel.font textView:nil];
	modelHeight += contentHeight;
    
    modelHeight += 15;
    modelHeight += 1 / [UIScreen mainScreen].scale;
	
    __block CGFloat tableHeight = 0;
    [self.replyTableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
        sectionMaker.modelArray(model.son);
    }];
    [self.replyTableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
        tableHeight = sectionMaker.section.sumRowHeight;
    }];
    
    [self.replyTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(tableHeight);
    }];
    
    if (model.son.count) {
        
        self.separatorLineView.hidden = false;
        
        modelHeight += tableHeight;
        
    } else {
        self.separatorLineView.hidden = true;
    }
    
	[model ht_setRowHeightNumber:@(modelHeight) forCellClass:self.class];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.headImageView.layer.cornerRadius = self.headImageView.bounds.size.height / 2;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	[super setHighlighted:highlighted animated:animated];
	[self.replyTableView ht_setBackgroundColor: highlighted ? self.selectedBackgroundView.backgroundColor : [UIColor clearColor]];
}

- (UIImageView *)headImageView {
	if (!_headImageView) {
		_headImageView = [[UIImageView alloc] init];
		_headImageView.layer.masksToBounds = true;
	}
	return _headImageView;
}

- (UILabel *)nicknameLabel {
	if (!_nicknameLabel) {
		_nicknameLabel = [[UILabel alloc] init];
		_nicknameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_nicknameLabel.font = [UIFont systemFontOfSize:15];
	}
	return _nicknameLabel;
}

- (UILabel *)sendTimeLabel {
	if (!_sendTimeLabel) {
		_sendTimeLabel = [[UILabel alloc] init];
		_sendTimeLabel.textColor = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
		_sendTimeLabel.font = [UIFont systemFontOfSize:13];
	}
	return _sendTimeLabel;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_titleNameLabel.font = [UIFont systemFontOfSize:15];
		_titleNameLabel.numberOfLines = 0;
	}
	return _titleNameLabel;
}

- (UIView *)separatorLineView {
    if (!_separatorLineView) {
        _separatorLineView = [[UIView alloc] init];
        _separatorLineView.backgroundColor = [UIColor ht_colorString:@"f3f3f3"];
    }
    return _separatorLineView;
}


- (UITableView *)replyTableView {
    if (!_replyTableView) {
        _replyTableView = [[UITableView alloc] init];
        _replyTableView.scrollEnabled = false;
		_replyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        __weak typeof(self) weakSelf = self;
        [_replyTableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [sectionMaker.cellClass([HTDiscussReplyCell class]) didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof HTDiscussReplyModel *model) {
				NSString *replyCommentid = model.replyCommentid;
				NSString *replyNickname = model.replyNickname;
                NSString *placholder = [NSString stringWithFormat:@"回复%@", replyNickname];
                UIKeyboardAppearance appearance = UIKeyboardAppearanceDark;
                [HTCommunityReplyKeyBoardView showReplyKeyBoardViewPlaceHodler:placholder keyBoardAppearance:appearance completeBlock:^(NSString *replyText) {
                    HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
                    networkModel.autoAlertString = @"发表回复";
                    networkModel.autoShowError = true;
                    networkModel.offlineCacheStyle = HTCacheStyleNone;
                    [HTRequestManager requestQuestionDiscussCreateWithNetworkModel:networkModel questionIdString:model.questionid discussContentString:replyText willReplyIdString:replyCommentid complete:^(id response, HTError *errorModel) {
                        if (errorModel.existError) {
                            return;
                        }
                        [HTAlert title:@"回复成功"];
                        
                        HTDiscussController *discuesController = (HTDiscussController *)weakSelf.ht_controller;
                        if ([discuesController isKindOfClass:[HTDiscussController class]]) {
                            [discuesController.tableView ht_startRefreshHeader];
                        }
                    }];
                }];
            }];
        }];
    }
    return _replyTableView;
}

- (void)setFrame:(CGRect)frame {
	frame.origin.y += 7;
	frame.size.height -= 7;
	[super setFrame:frame];
}

@end
