//
//  HTCommunityReplyContentView.m
//  GMat
//
//  Created by hublot on 2016/12/5.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTCommunityReplyContentView.h"
#import "HTCommunityReplyKeyBoardView.h"
#import "HTLoginManager.h"
#import "HTCommunityController.h"
#import "UIScrollView+HTRefresh.h"
#import "YYLabel.h"
#import "NSAttributedString+YYText.h"
#import "HTCommunityReplyContentLabel.h"


@interface HTCommunityReplyContentView ()

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSArray <HTCommunityReplyContentLabel *> *replyLabelArray;

@property (nonatomic, strong) YYLabel *replyLabel;

@end

@implementation HTCommunityReplyContentView

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self addSubview:self.lineView];
		[self addSubview:self.replyLabel];
        [self.replyLabelArray enumerateObjectsUsingBlock:^(HTCommunityReplyContentLabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addSubview:obj];
        }];
	}
	return self;
}

- (void)setModel:(HTCommunityLayoutModel *)model {
	_model = model;
	if (model.originModel.reply.count > CommunityReplyTableMaxCount) {
		self.replyLabel.ht_y = model.replyContentHeight - CommunityReplyTableFootHeight;
		self.replyLabel.hidden = false;
		self.replyLabel.textLayout = model.lookMoreReplyLayout;
	} else {
		self.replyLabel.hidden = true;
	}
	__block CGFloat nowHeight = 1 / [UIScreen mainScreen].scale;
	[self.replyLabelArray enumerateObjectsUsingBlock:^(HTCommunityReplyContentLabel * _Nonnull replyContentLabel, NSUInteger labelIndex, BOOL * _Nonnull stop) {
		if (labelIndex >= self.model.replyLayoutModelArray.count) {
			replyContentLabel.hidden = true;
		} else {
			replyContentLabel.hidden = false;
            HTCommunityReplyLayoutModel *replyLayoutModel = self.model.replyLayoutModelArray[labelIndex];
            replyContentLabel.frame = CGRectMake(0, nowHeight, HTSCREENWIDTH, replyLayoutModel.titleNameHeight);
            replyContentLabel.model = replyLayoutModel;
			nowHeight += replyContentLabel.ht_h;
            UITapGestureRecognizer *gesture = [replyContentLabel ht_whenTap:^(UIView *view) {
                [HTCommunityReplyKeyBoardView showReplyKeyBoardViewPlaceHodler:[NSString stringWithFormat:@" @%@", replyLayoutModel.originReplyModel.uName] keyBoardAppearance:UIKeyboardAppearanceDark completeBlock:^(NSString *replyText) {
					HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
					networkModel.autoAlertString = @"回复中";
					networkModel.offlineCacheStyle = HTCacheStyleNone;
					networkModel.autoShowError = true;
					[HTRequestManager requestGossipReplyGossipLoopReplyWithNetworkModel:networkModel replyContent:replyText communityLayoutModel:model beingReplyModel:replyLayoutModel complete:^(id response, HTError *errorModel) {
						if (errorModel.existError) {
							return;
						}
						[HTAlert title:@"回复成功"];
						[((HTCommunityController *)self.ht_controller).tableView ht_startRefreshHeader];
					}];
                }];
            }];
            gesture.cancelsTouchesInView = false;
		}
	}];
	self.ht_h = model.replyContentHeight;
}

- (UIView *)lineView {
	if (!_lineView) {
		_lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HTSCREENWIDTH, 1 / [UIScreen mainScreen].scale)];
		_lineView.backgroundColor = [UIColor ht_colorStyle:HTColorStylePrimarySeparate];
	}
	return _lineView;
}

- (NSArray<HTCommunityReplyContentLabel *> *)replyLabelArray {
	if (!_replyLabelArray) {
		NSMutableArray *replyLabelArray = [@[] mutableCopy];
		for (NSInteger index = 0; index < CommunityReplyTableMaxCount; index ++) {
			HTCommunityReplyContentLabel *replyContentLabel = [[HTCommunityReplyContentLabel alloc] initWithFrame:CGRectMake(0, 0, HTSCREENWIDTH, 0)];
			[replyLabelArray addObject:replyContentLabel];
		}
		_replyLabelArray = replyLabelArray;
	}
	return _replyLabelArray;
}

- (YYLabel *)replyLabel {
	if (!_replyLabel) {
		_replyLabel = [[YYLabel alloc] initWithFrame:CGRectMake((HTSCREENWIDTH - CommunityCellContentWidth) / 2, 0, CommunityCellContentWidth, CommunityReplyTableFootHeight)];
		_replyLabel.displaysAsynchronously = YES;
		_replyLabel.ignoreCommonProperties = YES;
		_replyLabel.fadeOnHighlight = NO;
		_replyLabel.fadeOnAsynchronouslyDisplay = NO;
	}
	return _replyLabel;
}

@end
