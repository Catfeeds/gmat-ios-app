//
//  HTUpdateVersionView.m
//  GMat
//
//  Created by hublot on 2017/7/18.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTUpdateVersionView.h"

@interface HTUpdateVersionView ()

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIView *whiteContentView;

@property (nonatomic, strong) UIImageView *fireImageView;

@property (nonatomic, strong) UITextView *titleTextView;

@property (nonatomic, strong) UIButton *bottomSureButton;

@property (nonatomic, strong) UIButton *dismissCircleButton;

@end

@implementation HTUpdateVersionView

+ (void)showWithSureBlock:(void(^)(void))sureBlock attributedString:(NSAttributedString *)attributedString animate:(BOOL)animated superView:(UIView *)superView {
	HTUpdateVersionView *updateVersionView = [[HTUpdateVersionView alloc] init];
	
	__weak HTUpdateVersionView *weakUpdateVersionView = updateVersionView;
	[superView addSubview:updateVersionView.backgroundView];
	[updateVersionView.backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
	[updateVersionView.backgroundView addSubview:updateVersionView];
	[updateVersionView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.center.mas_equalTo(updateVersionView.backgroundView);
		make.width.mas_equalTo(280);
		make.height.mas_equalTo(450);
	}];
	updateVersionView.titleTextView.attributedText = attributedString;
	[updateVersionView.bottomSureButton ht_whenTap:^(UIView *view) {
		if (sureBlock) {
			sureBlock();
		}
		[updateVersionView dismissWithAnimated:true];
	}];
	[updateVersionView.dismissCircleButton ht_whenTap:^(UIView *view) {
		[weakUpdateVersionView dismissWithAnimated:animated];
	}];
	
	[updateVersionView startAnimation:animated show:true];
}

- (void)dealloc {
	
}

- (void)startAnimation:(BOOL)animated show:(BOOL)show {
	void(^willShowStateBlock)(void) = ^() {
		self.backgroundView.alpha = 0;
		self.transform = CGAffineTransformMakeScale(0.8, 0.8);
	};
	void(^willHiddenStateBlock)(void) = ^() {
		self.backgroundView.alpha = 1;
		self.transform = CGAffineTransformIdentity;
	};
	if (show) {
		willShowStateBlock();
	} else {
		willHiddenStateBlock();
	}
	[UIView animateWithDuration:animated ? 0.25 : 0 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		if (show) {
			willHiddenStateBlock();
		} else {
			willShowStateBlock();
		}
	} completion:^(BOOL finished) {
		if (!show) {
			[self.backgroundView removeFromSuperview];
			[self removeFromSuperview];
		}
	}];
}

- (void)dismissWithAnimated:(BOOL)animated {
	[self startAnimation:animated show:false];
}

- (void)didMoveToSuperview {
	[self addSubview:self.whiteContentView];
	[self addSubview:self.fireImageView];
	[self addSubview:self.titleTextView];
	[self addSubview:self.bottomSureButton];
	[self addSubview:self.dismissCircleButton];
	[self.dismissCircleButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.bottom.mas_equalTo(self);
		make.centerX.mas_equalTo(self);
	}];
	[self.fireImageView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self);
		make.centerX.mas_equalTo(self);
	}];
	[self.whiteContentView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self).offset(60);
		make.left.right.mas_equalTo(self);
		make.bottom.mas_equalTo(self.dismissCircleButton.mas_top);
	}];
	[self.bottomSureButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.centerX.mas_equalTo(self);
		make.width.mas_equalTo(170);
		make.height.mas_equalTo(40);
		make.bottom.mas_equalTo(self.whiteContentView).offset(- 25);
	}];
	[self.titleTextView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.fireImageView.mas_bottom).offset(15);
		make.left.mas_equalTo(self).offset(10);
		make.right.mas_equalTo(self).offset(- 10);
		make.bottom.mas_equalTo(self.bottomSureButton.mas_top).offset(- 15);
	}];
}

- (UIView *)backgroundView {
	if (!_backgroundView) {
		_backgroundView = [[UIView alloc] init];
		_backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
	}
	return _backgroundView;
}

- (UIView *)whiteContentView {
	if (!_whiteContentView) {
		_whiteContentView = [[UIView alloc] init];
		_whiteContentView.backgroundColor = [UIColor whiteColor];
		_whiteContentView.layer.cornerRadius = 4;
		_whiteContentView.layer.masksToBounds = true;
	}
	return _whiteContentView;
}

- (UIImageView *)fireImageView {
	if (!_fireImageView) {
		_fireImageView = [[UIImageView alloc] init];
		UIImage *image = [UIImage imageNamed:@"ManagerVersionUpdate"];
		image = [image ht_resetSizeZoomNumber:0.5];
		_fireImageView.image = image;
	}
	return _fireImageView;
}

- (UITextView *)titleTextView {
	if (!_titleTextView) {
		_titleTextView = [[UITextView alloc] init];
		_titleTextView.alwaysBounceVertical = true;
		_titleTextView.editable = false;
	}
	return _titleTextView;
}

- (UIButton *)bottomSureButton {
	if (!_bottomSureButton) {
		_bottomSureButton = [[UIButton alloc] init];
		_bottomSureButton.titleLabel.font = [UIFont systemFontOfSize:15];
		[_bottomSureButton setTitle:@"立即更新" forState:UIControlStateNormal];
		
		UIColor *tintColor = [UIColor ht_colorString:@"00c5ab"];
		[_bottomSureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[_bottomSureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
		
		UIColor *hilightBackgroundColor = [tintColor colorWithAlphaComponent:0.5];
		[_bottomSureButton setBackgroundImage:[UIImage ht_pureColor:tintColor] forState:UIControlStateNormal];
		[_bottomSureButton setBackgroundImage:[UIImage ht_pureColor:hilightBackgroundColor] forState:UIControlStateHighlighted];
		
		_bottomSureButton.layer.cornerRadius = 3;
		_bottomSureButton.layer.masksToBounds = true;
	}
	return _bottomSureButton;
}

- (UIButton *)dismissCircleButton {
	if (!_dismissCircleButton) {
		_dismissCircleButton = [[UIButton alloc] init];
		UIImage *image = [UIImage imageNamed:@"HTUpdateDelete"];
		image = [image ht_resetSizeZoomNumber:0.55];
		[_dismissCircleButton setImage:image forState:UIControlStateNormal];
		_dismissCircleButton.contentEdgeInsets = UIEdgeInsetsMake(30, 30, 30, 30);
	}
	return _dismissCircleButton;
}

@end
