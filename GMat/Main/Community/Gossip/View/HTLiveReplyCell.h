//
//  HTLiveReplyCell.h
//  GMat
//
//  Created by Charles Cao on 2017/11/10.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTCommunityModel.h"

typedef NS_ENUM(NSUInteger, HTLiveReplyCellType) {
	HTLiveReplyCellTypeList = 1, //默认,用于直播列表
	HTliveReplyCellTypeDetail, 		// 用于详情页,有追问
};

@protocol HTLiveReplyCellDelegate <NSObject>

//点击点赞(tag:100) 打赏(tag:101) 追问(tag:102)    reply 评论
- (void)clickButton:(UIButton *)btn reply:(CommunityReply *)reply communityLayoutModel:(HTCommunityLayoutModel *) communityLayoutModel;

/*回复直播详情评论
 *
 * reply 要回复的评论
 * communityModel  要回复的帖子
 *
 */
 @optional
- (void)replyToReply:(CommunityReply *)reply communityModel:(HTCommunityModel *)communityModel;

@end

@interface HTLiveReplyCell : UITableViewCell <UITableViewDelegate,UITableViewDataSource>

@property (assign, nonatomic) HTLiveReplyCellType type;
@property (assign, nonatomic) id<HTLiveReplyCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UIButton *rewardButton;
@property (weak, nonatomic) IBOutlet UIButton *continueAskButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (nonatomic, strong) CommunityReply *reply;
@property (nonatomic, strong) HTCommunityLayoutModel *layoutModel;

//追问下面三角形图片
@property (weak, nonatomic) IBOutlet UIImageView *askImageView;
//三角形 icon 高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *askImageViewHeight;  //高度10;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottom; //table 底部间距  默认 7


@property (weak, nonatomic) IBOutlet UITableView *askTableView;


@end
