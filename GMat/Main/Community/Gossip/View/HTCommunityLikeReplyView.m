//
//  HTCommunityLikeReplyView.m
//  GMat
//
//  Created by hublot on 2016/11/22.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTCommunityLikeReplyView.h"
#import "NSAttributedString+YYText.h"
#import "YYAsyncLayer.h"
#import <UIButton+HTButtonCategory.h>
#import "HTCommunityLayoutModel.h"

@interface HTCommunityLikeReplyView ()

@end

@implementation HTCommunityLikeReplyView

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self addSubview:self.communityLikeButton];
		[self addSubview:self.communityReplyButton];
        [self addSubview:self.deleteButton];
	}
	return self;
}

- (void)updateCommunityLayout {
    
	CGFloat TitleImageDistance = 5;
	CGFloat likeToReplyDistance = 20;
	[self.communityReplyButton ht_makeEdgeWithDirection:HTButtonEdgeDirectionHorizontal imageViewToTitleLabelSpeceOffset:TitleImageDistance];
	[self.communityLikeButton ht_makeEdgeWithDirection:HTButtonEdgeDirectionHorizontal imageViewToTitleLabelSpeceOffset:TitleImageDistance];
    [self.communityReplyButton sizeToFit];
    [self.communityLikeButton sizeToFit];
	self.communityReplyButton.ht_x = self.ht_w - self.communityReplyButton.ht_w - (HTSCREENWIDTH - CommunityCellContentWidth) / 2;
	self.communityLikeButton.ht_x = self.communityReplyButton.ht_x - self.communityLikeButton.ht_w - likeToReplyDistance;
    self.deleteButton.ht_x = (HTSCREENWIDTH - CommunityCellContentWidth) / 2;
	self.communityLikeButton.ht_cy = CommunityLikeReplyViewHeight / 2;
	self.communityReplyButton.ht_cy = CommunityLikeReplyViewHeight / 2;
    self.deleteButton.ht_cy = CommunityLikeReplyViewHeight / 2;;
    
}

- (void)setCommunityLikeCount:(NSInteger)communityLikeCount {
	_communityLikeCount = communityLikeCount;
	[self.communityLikeButton setTitle:[NSString stringWithFormat:@"%ld", communityLikeCount] forState:UIControlStateNormal];
	[self updateCommunityLayout];
}

- (void)setCommunityReplyCount:(NSInteger)communityReplyCount {
	_communityReplyCount = communityReplyCount;
	[self.communityReplyButton setTitle:[NSString stringWithFormat:@"%ld", communityReplyCount] forState:UIControlStateNormal];
	[self updateCommunityLayout];
}

- (UIButton *)communityLikeButton {
	if (!_communityLikeButton) {
		_communityLikeButton = [[UIButton alloc] init];
		_communityLikeButton.tintColor = [UIColor orangeColor];
		[_communityLikeButton setImage:[[[UIImage imageNamed:@"Community3"] ht_resetSizeZoomNumber:1.3] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
		[_communityLikeButton setImage:[[[UIImage imageNamed:@"Community3"] ht_resetSizeZoomNumber:1.3] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
		[_communityLikeButton setTitleColor:[UIColor ht_colorStyle:HTColorStyleSecondaryTitle] forState:UIControlStateNormal];
		[_communityLikeButton setTitleColor:_communityLikeButton.tintColor forState:UIControlStateSelected];
		_communityLikeButton.titleLabel.font = [UIFont systemFontOfSize:12];
	}
	return _communityLikeButton;
}

- (UIButton *)communityReplyButton {
	if (!_communityReplyButton) {
		_communityReplyButton = [[UIButton alloc] init];
		[_communityReplyButton setImage:[[UIImage imageNamed:@"Community4"] ht_resetSize:self.communityLikeButton.currentImage.size] forState:UIControlStateNormal];
		_communityReplyButton.titleLabel.font = [UIFont systemFontOfSize:12];
		[_communityReplyButton setTitleColor:[UIColor ht_colorStyle:HTColorStyleSecondaryTitle] forState:UIControlStateNormal];
	}
	return _communityReplyButton;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
        
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor ht_colorStyle:HTColorStyleSecondaryTitle] forState:UIControlStateNormal];
    }
    return _deleteButton;
}





@end
