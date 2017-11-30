//
//  HTCommunityModel.h
//  GMat
//
//  Created by hublot on 2016/11/22.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CommunityReply;




@interface HTCommunityModel : NSObject



@property (nonatomic, copy) NSString *Id;

@property (nonatomic, copy) NSString *video;

@property (nonatomic, copy) NSString *like;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *audio;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) NSArray<NSString *> *image;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *publisher;

@property (nonatomic, copy) NSString *viewCount;

@property (nonatomic, copy) NSString *belong;

@property (nonatomic, strong) NSArray<CommunityReply *> *reply;

@property (nonatomic, assign) BOOL likeId;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *likeNum;

@property (nonatomic, assign) NSInteger integral;

@end



@interface CommunityReply : NSObject

@property (nonatomic, copy) NSString *replyUser;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *Id;

@property (nonatomic, copy) NSString *gossipId;

@property (nonatomic, copy) NSString *isLook;

@property (nonatomic, copy) NSString *replyUserName;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *uName;

@property (nonatomic, copy) NSString *userImage;
@property (nonatomic, copy) NSArray<CommunityReply *> *asked;
@property (nonatomic, assign) NSInteger likeNum; //点赞数
@property (nonatomic, assign) NSInteger liveId;
@property (nonatomic, assign) NSInteger likeSign; //当前用户是否点赞
@property (nonatomic, assign) NSInteger reward; //打赏数量
@property (nonatomic, assign) NSInteger askNum; //追问数量
@property (nonatomic, strong) NSString *pid;

@end

