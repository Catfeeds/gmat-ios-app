//
//  HTCommunityReplyKeyBoardView.m
//  GMat
//
//  Created by hublot on 2016/12/5.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTCommunityReplyKeyBoardView.h"
#import "HTLoginManager.h"
#import "HTManagerController.h"


@interface HTCommunityReplyKeyBoardView () <UITextViewDelegate>

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UITextView *replyTextView;

@property (nonatomic, strong) UITextView *placeTextView;

@property (nonatomic, assign) UIKeyboardAppearance keyBoardAppearance;

@property (nonatomic, copy) void(^completeBlock)(NSString *replyText);

@end

@implementation HTCommunityReplyKeyBoardView

static HTCommunityReplyKeyBoardView *replyKeyBoardView;

- (void)didMoveToSuperview {
	[self addSubview:self.contentView];
	[self.contentView addSubview:self.replyTextView];
	[self.contentView addSubview:self.placeTextView];
	[self ht_whenTap:^(UIView *view) {
		[self removeFromSuperview];
	}];
	[self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.right.bottom.mas_equalTo(self);
	}];
	[self.replyTextView bk_removeAllBlockObservers];
	[self.replyTextView bk_addObserverForKeyPath:@"contentSize" options:NSKeyValueObservingOptionInitial task:^(id obj, NSDictionary *change) {
		if (self.replyTextView.contentSize.height < 150) {
			[self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
				make.height.mas_equalTo(self.replyTextView.contentSize.height + 20);
			}];
		}
	}];
	[self.replyTextView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(self.contentView).mas_offset(UIEdgeInsetsMake(10, 10, 10, 10));
	}];
	[self.placeTextView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(self.replyTextView);
	}];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationKeyBoard:) name:UIKeyboardWillHideNotification object:nil];
}

+ (void)showReplyKeyBoardViewPlaceHodler:(NSString *)placeHodler keyBoardAppearance:(UIKeyboardAppearance)keyBoardAppearance completeBlock:(void(^)(NSString *replyText))completeBlock {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		replyKeyBoardView = [[HTCommunityReplyKeyBoardView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	});
	replyKeyBoardView.keyBoardAppearance = keyBoardAppearance;
	replyKeyBoardView.completeBlock = completeBlock;
	[[UIApplication sharedApplication].keyWindow addSubview:replyKeyBoardView];
	if (![replyKeyBoardView.placeTextView.text isEqualToString:placeHodler]) {
		replyKeyBoardView.replyTextView.text = @"";
		replyKeyBoardView.replyTextView.contentSize = CGSizeMake(replyKeyBoardView.replyTextView.contentSize.width, 30);
	}
	[replyKeyBoardView textViewDidChange:replyKeyBoardView.replyTextView];
	replyKeyBoardView.placeTextView.text = placeHodler;
	replyKeyBoardView.placeTextView.keyboardAppearance = keyBoardAppearance;
	replyKeyBoardView.replyTextView.keyboardAppearance = keyBoardAppearance;
	[replyKeyBoardView.replyTextView becomeFirstResponder];
}

- (void)notificationKeyBoard:( NSNotification *)notification {
	NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
	NSValue *keyboardBoundsValue = [[notification userInfo ] objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGRect keyboardBounds;
	[keyboardBoundsValue getValue:&keyboardBounds];
	CGFloat originHeight = keyboardBoundsValue.CGRectValue.size.height;
	[UIView animateWithDuration:duration.doubleValue animations:^{
		if (notification.name == UIKeyboardWillShowNotification) {
			self.ht_y = - originHeight;
		} else {
			self.ht_y = 0;
		}
	} completion:^(BOOL finished) {
		
	}];
}

//------------------------------------/ 代理 /------------------------------------//


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if ([text isEqualToString:@"\n"]) {
		[HTUserManager surePermissionHighOrEqual:HTUserPermissionExerciseAbleUser passCompareBlock:^(HTUser *user) {
			if (textView.hasText) {
				if (self.completeBlock) {
					self.completeBlock(self.replyTextView.text);
				}
				self.replyTextView.text = @"";
				[self removeFromSuperview];
			} else {
				[HTAlert title:@"什么都没有填写哦"];
			}
		}];
		return NO;
	}
	return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
	return true;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
	return true;
}

- (void)textViewDidChange:(UITextView *)textView {
	self.placeTextView.hidden = textView.hasText;
}

//------------------------------------/ 懒加载 /------------------------------------//


- (UIView *)contentView {
	if (!_contentView) {
		_contentView = [[UIView alloc] init];
		_contentView.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
		[_contentView ht_whenTap:^(UIView *view) {
			
		}];
	}
	return _contentView;
}

- (UITextView *)replyTextView {
	if (!_replyTextView) {
		_replyTextView = [[UITextView alloc] init];
		_replyTextView.backgroundColor = [UIColor whiteColor];
		_replyTextView.layer.cornerRadius = 15;
		_replyTextView.layer.masksToBounds = true;
		_replyTextView.textContainerInset = UIEdgeInsetsMake(6, 8, 6, 8);
		_replyTextView.font = [UIFont systemFontOfSize:15];
		_replyTextView.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_replyTextView.delegate = self;
		_replyTextView.returnKeyType = UIReturnKeySend;
	}
	return _replyTextView;
}

- (UITextView *)placeTextView {
	if (!_placeTextView) {
		_placeTextView = [[UITextView alloc] init];
		_placeTextView.backgroundColor = [UIColor clearColor];
		_placeTextView.layer.cornerRadius = 15;
		_placeTextView.layer.masksToBounds = true;
		_placeTextView.textContainerInset = UIEdgeInsetsMake(6, 8, 6, 8);
		_placeTextView.font = [UIFont systemFontOfSize:15];
		_placeTextView.textColor = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
		_placeTextView.delegate = self;
		_placeTextView.returnKeyType = UIReturnKeySend;
		_placeTextView.userInteractionEnabled = false;
	}
	return _placeTextView;
}


@end
