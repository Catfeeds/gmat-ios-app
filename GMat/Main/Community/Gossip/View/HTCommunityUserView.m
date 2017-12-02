//
//  HTCommunityUserView.m
//  GMat
//
//  Created by hublot on 2016/11/22.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTCommunityUserView.h"
#import "HTCommunityLayoutModel.h"

@implementation HTCommunityUserView

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.headImageView.center = CGPointMake(CommunityUserHeadImageHeight / 2 + (HTSCREENWIDTH - CommunityCellContentWidth) / 2, frame.size.height / 2);
		[self addSubview:self.headImageView];
        self.userNameLabel.ht_y = self.headImageView.ht_y;
		[self addSubview:self.userNameLabel];
        self.creatTimeLabel.ht_y = self.headImageView.ht_y + self.headImageView.ht_h - self.creatTimeLabel.ht_h;
		[self addSubview:self.creatTimeLabel];
	}
	return self;
}

- (UIView *)headImageView {
	if (!_headImageView) {
		_headImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CommunityUserHeadImageHeight, CommunityUserHeadImageHeight)];
	}
	return _headImageView;
}

- (YYLabel *)userNameLabel {
	if (!_userNameLabel) {
		_userNameLabel = [[YYLabel alloc] initWithFrame:CGRectMake((CommunityUserHeadImageHeight / 2 + (HTSCREENWIDTH - CommunityCellContentWidth) / 2) * 2, 0, CommunityUserViewTextWidth, CommunityUserHeadImageHeight / 2)];
//        _userNameLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
		_userNameLabel.displaysAsynchronously = YES;
		_userNameLabel.ignoreCommonProperties = YES;
		_userNameLabel.fadeOnHighlight = NO;
		_userNameLabel.fadeOnAsynchronouslyDisplay = NO;
	}
	return _userNameLabel;
}

- (YYLabel *)creatTimeLabel {
	if (!_creatTimeLabel) {
		_creatTimeLabel = [[YYLabel alloc] initWithFrame:CGRectMake((CommunityUserHeadImageHeight / 2 + (HTSCREENWIDTH - CommunityCellContentWidth) / 2) * 2, 0, CommunityUserViewTextWidth, CommunityUserHeadImageHeight / 2)];
//        _creatTimeLabel.textVerticalAlignment = YYTextVerticalAlignmentBottom;
		_creatTimeLabel.displaysAsynchronously = YES;
		_creatTimeLabel.ignoreCommonProperties = YES;
		_creatTimeLabel.fadeOnHighlight = NO;
		_creatTimeLabel.fadeOnAsynchronouslyDisplay = NO;
	}
	return _creatTimeLabel;
}

@end
