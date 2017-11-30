//
//  HTCommunityMessageController.h
//  GMat
//
//  Created by hublot on 2016/11/23.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HTCommunityMessageControllerType) {
	HTCommunityMessage = 0,  //吐槽未读消息
	HTLiveMessage			//直播未读消息
};

@interface HTCommunityMessageController : UIViewController

@property (nonatomic, assign) HTCommunityMessageControllerType type;

- (id)initWithtype:(HTCommunityMessageControllerType) type;

@end
