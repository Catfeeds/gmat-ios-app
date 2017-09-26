//
//  HTCommunityMessageLayoutModel.m
//  GMat
//
//  Created by hublot on 17/1/15.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTCommunityMessageLayoutModel.h"
#import "NSAttributedString+YYText.h"

@implementation HTCommunityUserViewLayoutModel (Message)

+ (instancetype)userViewReplyModelWithMessageModel:(HTCommunityMessageModel *)messageModel {
    HTCommunityUserViewLayoutModel *userViewLayoutModel = [[HTCommunityUserViewLayoutModel alloc] init];
    
    // 名字
    NSMutableAttributedString *userViewTitleNameAttributedString = [[NSMutableAttributedString alloc] initWithString:messageModel.userName];
    userViewTitleNameAttributedString.font = [UIFont systemFontOfSize:CommunityUserViewTitleFontSize];
    userViewTitleNameAttributedString.color = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
    userViewTitleNameAttributedString.lineBreakMode = NSLineBreakByCharWrapping;
    YYTextContainer *userViewTitleNameTextContainer = [YYTextContainer containerWithSize:CGSizeMake(CommunityUserViewTextWidth - CommunityCellContentEdge * 2 - CommunityMessageRightContentWidth, 9999)];
    userViewTitleNameTextContainer.maximumNumberOfRows = 1;
    userViewLayoutModel.userViewTitleNameLayout = [YYTextLayout layoutWithContainer:userViewTitleNameTextContainer text:userViewTitleNameAttributedString];
    
    // 内容
    NSMutableAttributedString *userViewDetailNameAttributedString = [[NSMutableAttributedString alloc] initWithString:messageModel.content];
    userViewDetailNameAttributedString.font = [UIFont systemFontOfSize:CommunityUserViewDetailFontSize];
    userViewDetailNameAttributedString.color = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
    userViewDetailNameAttributedString.lineBreakMode = NSLineBreakByWordWrapping;

    WBTextLinePositionModifier *detailNameModifier = [WBTextLinePositionModifier new];
    detailNameModifier.font = [UIFont fontWithName:@"Heiti SC" size:CommunityUserViewDetailFontSize];
    detailNameModifier.paddingTop = CommunityImagePadding;
    
    YYTextContainer *detailTextContainer = [[YYTextContainer alloc] init];
    detailTextContainer.size = CGSizeMake(CommunityUserViewTextWidth - CommunityCellContentEdge - CommunityMessageRightContentWidth, 9999);
    detailTextContainer.linePositionModifier = detailNameModifier;
    
    userViewLayoutModel.userViewDetailNameLayout = [YYTextLayout layoutWithContainer:detailTextContainer text:userViewDetailNameAttributedString];
    userViewLayoutModel.userViewAutoLabelHeight = MAX(CommunityUserHeadImageHeight / 2, [detailNameModifier heightForLineCount:userViewLayoutModel.userViewDetailNameLayout.rowCount]) ;
    
    // 整个userView 高度
    userViewLayoutModel.userViewHeight = CommunityUserViewHeight - CommunityUserHeadImageHeight / 2  + userViewLayoutModel.userViewAutoLabelHeight;
    
    return userViewLayoutModel;
}

@end

@implementation HTCommunityMessageLayoutModel

+ (instancetype)messageLayoutModelWithMessageModel:(HTCommunityMessageModel *)messageModel {
    HTCommunityMessageLayoutModel *messageLayoutModel = [[HTCommunityMessageLayoutModel alloc] init];
    messageLayoutModel.originModel = messageModel;
    messageLayoutModel.userViewLayoutModel = [HTCommunityUserViewLayoutModel userViewReplyModelWithMessageModel:messageModel];
    
    NSMutableAttributedString *messageAttributedString = [[NSMutableAttributedString alloc] initWithString:messageModel.gossipContent];
    messageAttributedString.font = [UIFont systemFontOfSize:CommunityMessageRightContentFontSize];
    messageAttributedString.color = [UIColor whiteColor];
    
    WBTextLinePositionModifier *messageModifier = [WBTextLinePositionModifier new];
    messageModifier.font = [UIFont fontWithName:@"Heiti SC" size:CommunityMessageRightContentFontSize];
    
    YYTextContainer *messageTextContainer = [[YYTextContainer alloc] init];
    messageTextContainer.size = CGSizeMake(CommunityMessageRightContentWidth, HUGE);
    messageTextContainer.linePositionModifier = messageModifier;
    messageTextContainer.maximumNumberOfRows = CommunityMessageRightContentLineNumber;
    
    messageLayoutModel.messageTextLayout = [YYTextLayout layoutWithContainer:messageTextContainer text:messageAttributedString];
    messageLayoutModel.messageHeight = [messageModifier heightForLineCount:messageLayoutModel.messageTextLayout.lines.count];
    
    return messageLayoutModel;
}

@end
