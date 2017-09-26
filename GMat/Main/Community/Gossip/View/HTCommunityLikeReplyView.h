//
//  HTCommunityLikeReplyView.h
//  GMat
//
//  Created by hublot on 2016/11/22.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTCommunityLikeReplyView : UIView

@property (nonatomic, assign) NSInteger communityLikeCount;

@property (nonatomic, assign) NSInteger communityReplyCount;


@property (nonatomic, strong) UIButton *communityLikeButton;

@property (nonatomic, strong) UIButton *communityReplyButton;

@end
