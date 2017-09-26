//
//  HTDiscussModel.h
//  GMat
//
//  Created by hublot on 2017/8/23.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTDiscussReplyModel;

@interface HTDiscussModel : NSObject

@property (nonatomic, copy) NSString *questionid;

@property (nonatomic, copy) NSString *commentid;

@property (nonatomic, strong) NSArray<HTDiscussReplyModel *> *son;

@property (nonatomic, copy) NSString *userid;

@property (nonatomic, copy) NSString *c_time;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *contentid;

@property (nonatomic, assign) NSInteger num;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *pid;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *content;

@end
@interface HTDiscussReplyModel : NSObject

@property (nonatomic, copy) NSString *questionid;

@property (nonatomic, copy) NSString *commentid;

@property (nonatomic, strong) NSArray<HTDiscussReplyModel *> *son;

@property (nonatomic, copy) NSString *userid;

@property (nonatomic, copy) NSString *c_time;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *contentid;

@property (nonatomic, assign) NSInteger num;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *pid;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *content;



@property (nonatomic, copy) NSString *replyCommentid;

@property (nonatomic, copy) NSString *replyNickname;

@end

