//
//  HTCommunityMessageLayoutModel.h
//  GMat
//
//  Created by hublot on 17/1/15.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTCommunityLayoutModel.h"
#import "HTCommunityMessageModel.h"
#import "YYTextLayout.h"


#define CommunityMessageRightContentWidth 80

#define CommunityMessageRightContentLineNumber 3

#define CommunityMessageRightContentFontSize 14



@interface HTCommunityMessageLayoutModel : NSObject

@property (nonatomic, strong) HTCommunityMessageModel *originModel;

@property (nonatomic, strong) HTCommunityUserViewLayoutModel *userViewLayoutModel;

@property (nonatomic, strong) YYTextLayout *messageTextLayout;

@property (nonatomic, assign) CGFloat messageHeight;

+ (instancetype)messageLayoutModelWithMessageModel:(HTCommunityMessageModel *)messageModel;

@end
