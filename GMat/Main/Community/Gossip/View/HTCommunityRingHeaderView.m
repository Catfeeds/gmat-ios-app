//
//  HTCommunityRingHeaderView.m
//  GMat
//
//  Created by hublot on 2016/11/24.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTCommunityRingHeaderView.h"

@implementation HTCommunityRingHeaderView

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor whiteColor];
	self.layer.masksToBounds = true;
	[self addSubview:self.communityRingView];
	[self.communityRingView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(HTADAPT568(140));
		make.height.mas_equalTo(HTADAPT568(30));
		make.center.mas_equalTo(self);
	}];
}

- (void)setRingCount:(NSInteger)ringCount completeBlock:(void(^)(void))completeBlock {
	self.communityRingView.titleNameLabel.text = ringCount > 99 ? @"你有 99+ 条新消息" : [NSString stringWithFormat:@"你有 %ld 条新消息", ringCount];
	self.communityRingView.ringLineView.ht_h = self.communityRingView.ringImageView.image.size.height;
	[self.communityRingView.titleNameLabel sizeToFit];
	[self.communityRingView ht_addStackDistanceWithSubViews:@[self.communityRingView.ringImageView, self.communityRingView.ringLineView, self.communityRingView.titleNameLabel] foreSpaceDistance:10 backSpaceDistance:10 stackDistanceDirection:HTStackDistanceDirectionHorizontal];
	self.ht_h = ringCount ? HTADAPT568(50) : 0;
	if (completeBlock) {
		completeBlock();
	}
}

- (HTCommunityRingView *)communityRingView {
	if (!_communityRingView) {
		_communityRingView = [[HTCommunityRingView alloc] initWithFrame:CGRectMake(0, 0, HTADAPT568(140), HTADAPT568(30))];
	}
	return _communityRingView;
}

@end
