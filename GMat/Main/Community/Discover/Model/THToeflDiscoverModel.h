//
//  THToeflDiscoverModel.h
//  TingApp
//
//  Created by hublot on 16/8/30.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THDiscoverReply;

@interface THToeflDiscoverModel : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSArray <NSString *> *radioTitle;

@property (nonatomic, strong) NSArray *radio;

@property (nonatomic, copy) NSString *cnContent;

@property (nonatomic, strong) NSArray <NSString *> *datum;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *hot;

@property (nonatomic, copy) NSString *catId;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) BOOL isReply;

@property (nonatomic, strong) NSArray *imageContent;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *viewCount;

@property (nonatomic, strong) NSArray<NSString *> *datumTitle;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *dateTime;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, strong) NSArray<THDiscoverReply *> *Reply;

@property (nonatomic, copy) NSString *content;


- (void)creatDetailAttributedString;

@property (nonatomic, strong) NSAttributedString *detailAttributedString;




@end
@interface THDiscoverReply : NSObject

@property (nonatomic, copy) NSString *postId;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *pid;

@end

