//
//  HTCommunityReplyKeyBoardView.h
//  GMat
//
//  Created by hublot on 2016/12/5.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ReplyKeyBoardAllowInput) {
	ReplyKeyBoardAllowInputEmoji,
	ReplyKeyBoardAllowInputAudio,
	ReplyKeyBoardAllowInputAt,
	ReplyKeyBoardAllowInputImage
};

@interface HTCommunityReplyKeyBoardView : UIView

+ (void)showReplyKeyBoardViewPlaceHodler:(NSString *)placeHodler keyBoardAppearance:(UIKeyboardAppearance)keyBoardAppearance completeBlock:(void(^)(NSString *replyText))completeBlock;

@end
