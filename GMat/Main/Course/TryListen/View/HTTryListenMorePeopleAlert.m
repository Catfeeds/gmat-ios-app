//
//  HTTryListenMorePeopleAlert.m
//  GMat
//
//  Created by hublot on 2017/8/3.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTTryListenMorePeopleAlert.h"

@interface HTTryListenMorePeopleAlert ()

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIImageView *cryImageView;

@property (nonatomic, strong) UIButton *dismissCircleButton;

@end

@implementation HTTryListenMorePeopleAlert

+ (void)showWithAnimted:(BOOL)animated superView:(UIView *)superView {
	HTTryListenMorePeopleAlert *trylistenAlert = [[HTTryListenMorePeopleAlert alloc] init];
	__weak typeof(trylistenAlert) weakTryListenAlert = trylistenAlert;
	[superView addSubview:trylistenAlert.backgroundView];
	[trylistenAlert.backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
	[trylistenAlert.backgroundView addSubview:trylistenAlert];
	[trylistenAlert mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
	[trylistenAlert.backgroundView ht_whenTap:^(UIView *view) {
		[weakTryListenAlert dismissWithAnimated:animated];
	}];
	[trylistenAlert.dismissCircleButton ht_whenTap:^(UIView *view) {
		[weakTryListenAlert dismissWithAnimated:animated];
	}];
	[trylistenAlert startAnimation:animated show:true];
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
	[self addSubview:self.cryImageView];
	[self addSubview:self.dismissCircleButton];
	[self.cryImageView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.center.mas_equalTo(self);
	}];
	[self.dismissCircleButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.cryImageView);
		make.right.mas_equalTo(self.cryImageView).offset(- 20);
	}];
}

- (UIView *)backgroundView {
	if (!_backgroundView) {
		_backgroundView = [[UIView alloc] init];
		_backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
	}
	return _backgroundView;
}

- (UIImageView *)cryImageView {
	if (!_cryImageView) {
		_cryImageView = [[UIImageView alloc] init];
		UIImage *image = [UIImage imageNamed:@"cn_trylisten_alert_cry"];
		CGFloat maxWidth = 300;
		CGFloat scale = maxWidth / image.size.width;
		image = [image ht_resetSizeZoomNumber:scale];
		_cryImageView.image = image;
	}
	return _cryImageView;
}

- (UIButton *)dismissCircleButton {
	if (!_dismissCircleButton) {
		_dismissCircleButton = [[UIButton alloc] init];
		UIImage *image = [UIImage imageNamed:@"cn_trylisten_alert_delete"];
		image = [image ht_resetSize:CGSizeMake(12, 12)];
		UIColor *backgroundColor = [UIColor ht_colorString:@"44a8fc"];
		image = [image ht_insertColor:backgroundColor edge:UIEdgeInsetsMake(8, 8, 8, 8)];
		image = [image ht_imageByRoundCornerRadius:image.size.width / 2 corners:UIRectCornerAllCorners borderWidth:0 borderColor:nil borderLineJoin:kCGLineJoinRound];
		[_dismissCircleButton setImage:image forState:UIControlStateNormal];
	}
	return _dismissCircleButton;
}

@end
