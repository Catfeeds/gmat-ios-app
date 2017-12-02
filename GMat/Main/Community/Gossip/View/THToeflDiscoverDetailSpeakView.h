//
//  THToeflDiscoverDetailSpeakView.h
//  TingApp
//
//  Created by hublot on 16/9/22.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, THToeflDiscoverDetailSpeakViewEditStyle) {
	THToeflDiscoverDetailSpeakViewEditStyleComment,
	THToeflDiscoverDetailSpeakViewEditStyleSubComment
};

@interface THToeflDiscoverDetailSpeakView : UIView

- (instancetype)initWithFrame:(CGRect)frame shouldBeginBlock:(void(^)(void))shouldBeginBlock shouldSendBlock:(void(^)(void))shouldSendBlock;

- (void)becomeFirstResponderWithStyle:(THToeflDiscoverDetailSpeakViewEditStyle)style placeHolder:(NSString *)placeHolder;

@property (nonatomic, strong) UITextView *placeTextView;

@property (nonatomic, assign) THToeflDiscoverDetailSpeakViewEditStyle style;

@property (nonatomic, strong) UIButton *headImageButton;

@property (nonatomic, strong) UITextView *speakTextView;

@end
