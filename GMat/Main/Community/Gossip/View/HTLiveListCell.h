//
//  HTLiveListCell.h
//  GMat
//
//  Created by Charles Cao on 2017/11/10.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTCommunityLayoutModel.h"
#import "HTLiveReplyCell.h"
#import "HTCommunityDetailHeaderView.h"

@protocol HTLiveListCellDelegate <NSObject>

/*回复直播列表评论
 *
 * reply 要回复的评论
 * communityModel  要回复的帖子
 *
 */
- (void)replyToReply:(CommunityReply *)reply communityLayoutModel:(HTCommunityLayoutModel *)communityLayoutModel;

@end

@interface HTLiveListCell : UITableViewCell

@property (nonatomic, assign) id<HTLiveListCellDelegate> delegate;
@property (nonatomic, assign) id<HTLiveReplyCellDelegate> clickButtonDelegate;
@property (nonatomic, assign) id<HTCommunityDetailHeaderViewDelegate> headerViewDelegate;

@property (weak, nonatomic) IBOutlet UIView *postContentView;

@property (weak, nonatomic) IBOutlet UITableView *replyTable;

@property (weak, nonatomic) IBOutlet UILabel *moreLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreLabelHeight;

@property (nonatomic, strong) HTCommunityLayoutModel *layoutModel;

@end
