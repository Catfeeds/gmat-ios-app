//
//  HTCommunityIssueController.h
//  GMat
//
//  Created by hublot on 2016/10/26.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HTKeyboardController.h>

@protocol HTCommunityIssueControllerDelete <NSObject>

//发帖成功
- (void)sendPostSuccess;

@end

typedef NS_ENUM(NSInteger, HTIssueContentType) {
	HTIssueContentGossip = 0, //发表吐槽
	HTIssueContentLive        //发表直播
	
};

@interface HTCommunityIssueController : HTKeyboardController

@property (nonatomic, assign) id<HTCommunityIssueControllerDelete> delegate;

@property (nonatomic, assign) HTIssueContentType type;

@end
