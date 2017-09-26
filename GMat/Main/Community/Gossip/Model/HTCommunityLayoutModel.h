//
//  HTCommunityLayoutModel.h
//  GMat
//
//  Created by hublot on 2017/1/12.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTCommunityModel.h"
#import "YYTextLayout.h"
#import "YYWebImageManager.h"

@class HTCommunityReplyLayoutModel, HTCommunityUserViewLayoutModel;

// cell 间的间距

#define CommunityCellMargin 7



// 头像的大小
#define CommunityUserHeadImageHeight 40

// userView 的高度
#define CommunityUserViewHeight 56

// userView 的用户名或发表时间长度
#define CommunityUserViewTextWidth (HTSCREENWIDTH - ((CommunityUserHeadImageHeight / 2 + (HTSCREENWIDTH - CommunityCellContentWidth) / 2) * 2) - ((HTSCREENWIDTH - CommunityCellContentWidth) / 2)) 

// userView 的标题字体大小
#define CommunityUserViewTitleFontSize 16

// userView 的详情字体大小
#define CommunityUserViewDetailFontSize 14





// cell 的内容长度
#define CommunityCellContentWidth (HTSCREENWIDTH - 30)

// 各种左右的边距

#define CommunityCellContentEdge ((HTSCREENWIDTH - CommunityCellContentWidth) / 2)

// cell 的详情的最大行数
#define CommunityDetailNameNumberOfLines 3

// cell 的文字间距
#define CommunityTextPadding 8





// 图片之间的间距
#define CommunityImagePadding 10





// 回复点赞的高度
#define CommunityLikeReplyViewHeight 35








// 回复的表格的内容长度
#define CommunityReplyTableContentWidth CommunityCellContentWidth

// 回复的文字字体大小
#define CommunityReplyTableViewCellFontSize 14

// 回复的最大行数
#define CommunityReplyCellNumberOfLines 2

// 回复的文字间距
#define CommunityReplyCellTextPading 6.5

// 回复的表格的底部的查看全部的文本高度
#define CommunityReplyTableFootHeight 30

// 回复的表格的最大 cell 个数
#define CommunityReplyTableMaxCount 5


@interface HTCommunityLayoutModel : NSObject

@property (nonatomic, strong) HTCommunityUserViewLayoutModel *userViewLayoutModel;


@property (nonatomic, assign) CGFloat titleNameLabelHeight;

@property (nonatomic, strong) YYTextLayout *titleNameLayout;




@property (nonatomic, assign) CGFloat detailNameLabelHeight;

@property (nonatomic, strong) YYTextLayout *detailNameLayout;




@property (nonatomic, assign) CGFloat imageCollectionViewHeight;




@property (nonatomic, assign) CGFloat likeReplyViewHeight;

@property (nonatomic, assign) CGFloat replyContentHeight;


@property (nonatomic, strong) HTCommunityModel *originModel;

@property (nonatomic, strong) NSArray <HTCommunityReplyLayoutModel *> *replyLayoutModelArray;

@property (nonatomic, strong) YYTextLayout *lookMoreReplyLayout;

+ (instancetype)layoutModelWithOriginModel:(HTCommunityModel *)orginModel isDetail:(BOOL)isDetail;

@end






@interface HTCommunityUserViewLayoutModel : NSObject

@property (nonatomic, assign) CGFloat userViewHeight;

@property (nonatomic, assign) CGFloat userViewAutoLabelHeight;

@property (nonatomic, strong) YYWebImageManager *headImageManager;

@property (nonatomic, strong) YYTextLayout *userViewTitleNameLayout;

@property (nonatomic, strong) YYTextLayout *userViewDetailNameLayout;

+ (instancetype)userViewReplyModelWithReplyModel:(CommunityReply *)replyModel;

+ (instancetype)userViewReplyModelWithCommunityModel:(HTCommunityModel *)communityModel;

@end






@interface HTCommunityReplyLayoutModel : NSObject

@property (nonatomic, assign) CGFloat titleNameHeight;

@property (nonatomic, strong) YYTextLayout *titleNameLayout;

@property (nonatomic, strong) CommunityReply *originReplyModel;

@property (nonatomic, strong) HTCommunityUserViewLayoutModel *userViewLayoutModel;

+ (instancetype)replyLayoutModelWithOriginReplyModel:(CommunityReply *)originReplyModel;

@end

























@interface WBTextLinePositionModifier : NSObject <YYTextLinePositionModifier>

@property (nonatomic, strong) UIFont *font; // 基准字体 (例如 Heiti SC/PingFang SC)

@property (nonatomic, assign) CGFloat paddingTop; //文本顶部留白

@property (nonatomic, assign) CGFloat paddingBottom; //文本底部留白

@property (nonatomic, assign) CGFloat lineHeightMultiple; //行距倍数

- (CGFloat)heightForLineCount:(NSUInteger)lineCount;

@end
