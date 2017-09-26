//
//  THToeflDiscoverDetailSpeakView.m
//  TingApp
//
//  Created by hublot on 16/9/22.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "THToeflDiscoverDetailSpeakView.h"
#import "HTLoginManager.h"


@interface THToeflDiscoverDetailSpeakView () <UITextViewDelegate>

@property (nonatomic, copy) void(^shouldSendBlockName)();

@property (nonatomic, copy) void(^shouldBeginBlockName)();

@end

@implementation THToeflDiscoverDetailSpeakView

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame shouldBeginBlock:(void(^)(void))shouldBeginBlock shouldSendBlock:(void(^)(void))shouldSendBlock {
	if (self = [super initWithFrame:frame]) {
		self.shouldBeginBlockName = shouldBeginBlock;
		self.shouldSendBlockName = shouldSendBlock;
	}
	return self;
}

- (void)becomeFirstResponderWithStyle:(THToeflDiscoverDetailSpeakViewEditStyle)style placeHolder:(NSString *)placeHolder {
	self.placeTextView.text = placeHolder;
	self.style = style;
	[self.speakTextView becomeFirstResponder];
}

- (void)didMoveToSuperview {
	[self loginChange];
	self.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginChange) name:kHTLoginNotification object:nil];
	[self addSubview:self.headImageButton];
	[self addSubview:self.speakTextView];
	[self addSubview:self.placeTextView];
	[self.headImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(15);
		make.width.height.mas_equalTo(30);
		make.top.mas_equalTo(self).offset(10);
	}];
	[self.speakTextView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.headImageButton.mas_right).offset(15);
		make.top.mas_equalTo(self).offset(10);
		make.bottom.mas_equalTo(self).offset(- 10);
		make.right.mas_equalTo(self).offset(- 15);
	}];
	[self.placeTextView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(self.speakTextView);
	}];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.headImageButton.layer.cornerRadius = self.headImageButton.ht_h / 2;
}

- (void)loginChange {
	[self.headImageButton sd_setImageWithURL:[NSURL URLWithString:GmatResourse([HTUserManager currentUser].photo)] forState:UIControlStateNormal placeholderImage:HTPLACEHOLDERIMAGE completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
		
	}];
}



//-----------------------------------------/ 代理 /-----------------------------------------//


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if ([text isEqualToString:@"\n"]) {
		[HTUserManager surePermissionHighOrEqual:HTUserPermissionExerciseAbleUser passCompareBlock:^(HTUser *user) {
			if (textView.hasText) {
				if (self.shouldSendBlockName) {
					self.shouldSendBlockName();
				}
			} else {
				[HTAlert title:@"什么都没有填写哦"];
			}
		}];
		return NO;
	}
	return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
	if (self.shouldBeginBlockName) {
		self.shouldBeginBlockName();
	}
	[self.headImageButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(0);
	}];
	[self.speakTextView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.headImageButton.mas_right).offset(0);
	}];
	[UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		[self layoutIfNeeded];
	} completion:nil];
	return true;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
	[self.headImageButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(30);
	}];
	[self.speakTextView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.headImageButton.mas_right).offset(15);
	}];
	[UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		[self layoutIfNeeded];
	} completion:nil];
	if (!self.speakTextView.hasText) {
		self.style = THToeflDiscoverDetailSpeakViewEditStyleComment;
		self.placeTextView.text = @"我也说一句";
	}
	return true;
}

- (void)textViewDidChange:(UITextView *)textView {
	self.placeTextView.hidden = textView.hasText;
}



//-----------------------------------------/ 懒加载 /-----------------------------------------//

- (UIButton *)headImageButton {
	if (!_headImageButton) {
		_headImageButton = [[UIButton alloc] init];
		_headImageButton.layer.cornerRadius = 15;
		_headImageButton.layer.masksToBounds = true;
	}
	return _headImageButton;
}

- (UITextView *)speakTextView {
	if (!_speakTextView) {
		_speakTextView = [[UITextView alloc] init];
		_speakTextView.backgroundColor = [UIColor whiteColor];
		_speakTextView.layer.cornerRadius = 15;
		_speakTextView.layer.masksToBounds = true;
		_speakTextView.textContainerInset = UIEdgeInsetsMake(6, 8, 6, 8);
		_speakTextView.font = [UIFont systemFontOfSize:14];
		_speakTextView.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_speakTextView.delegate = self;
		_speakTextView.returnKeyType = UIReturnKeySend;
	}
	return _speakTextView;
}

- (UITextView *)placeTextView {
	if (!_placeTextView) {
		NSData *tempTextView = [NSKeyedArchiver archivedDataWithRootObject:self.speakTextView];
		_placeTextView = [NSKeyedUnarchiver unarchiveObjectWithData:tempTextView];
		_placeTextView.text = @"我也说一句";
		_placeTextView.textColor = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
		_placeTextView.textContainerInset = UIEdgeInsetsMake(6, 8, 6, 8);
		_placeTextView.delegate = nil;
		_placeTextView.backgroundColor = [UIColor clearColor];
		_placeTextView.userInteractionEnabled = false;
	}
	return _placeTextView;
}


@end
