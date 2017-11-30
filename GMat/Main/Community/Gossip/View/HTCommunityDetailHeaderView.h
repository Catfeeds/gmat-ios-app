//
//  HTCommunityDetailHeaderView.h
//  GMat
//
//  Created by hublot on 2016/11/22.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTCommunityLayoutModel.h"
#import "HTCommunityUserView.h"
#import "HTCommunityReplyContentView.h"
#import "HTCommunityImageView.h"
#import "HTCommunityLikeReplyView.h"

#define DELETE  @"deleteGossip"

typedef NS_ENUM(NSInteger, HTCommunityDetailType) {
    HTCommunityTypeGossip,
    HTCommunityTypelLive,
    
};

@protocol HTCommunityDetailHeaderViewDelegate <NSObject>

//评论帖子成功
- (void)replyPostSuccessWithModel:(HTCommunityLayoutModel *)model reply:(CommunityReply *)newReply;

@end


@interface HTCommunityDetailHeaderView : UIView

@property (nonatomic, assign) id<HTCommunityDetailHeaderViewDelegate> delegate;

@property (nonatomic, strong) UIView *whiteContentView;

//对于直播页面的帖子内容高度,没有"吐槽页面的" CommunityCellMargin
@property (nonatomic, assign) CGFloat heightForLive;


//isShowDelete 是否显示删除按钮
- (void)setModel:(HTCommunityLayoutModel *)model row:(NSInteger)row type:(HTCommunityDetailType)type isShowDelete:(BOOL)isShowDelete;

@end
