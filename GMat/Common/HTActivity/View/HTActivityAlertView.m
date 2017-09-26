//
//  HTActivityAlertView.m
//  GMat
//
//  Created by hublot on 2017/8/24.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTActivityAlertView.h"
#import "HTWebController.h"

@interface HTActivityAlertView ()

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIImageView *contentImageView;

@property (nonatomic, strong) UIButton *dismissCircleButton;

@end

@implementation HTActivityAlertView

+ (void)showActivityWithAnimated:(BOOL)animated image:(UIImage *)image url:(NSString *)url superView:(UIView *)superView {
	UIImage *backgroundImage = image;
	CGFloat backgroundMaxWidth = HTSCREENWIDTH - 70;
	CGFloat backgroundMaxHeight = [UIScreen mainScreen].bounds.size.height - 300;
	if (backgroundImage.size.width > backgroundMaxWidth) {
		backgroundImage = [backgroundImage ht_resetSizeZoomNumber:backgroundMaxWidth / backgroundImage.size.width];
	}
	if (backgroundImage.size.height > backgroundMaxHeight) {
		backgroundImage = [backgroundImage ht_resetSizeZoomNumber:backgroundMaxHeight / backgroundImage.size.height];
	}
	
	
	HTActivityAlertView *activityAlert = [[HTActivityAlertView alloc] init];
	__weak typeof(activityAlert) weakActivityAlert = activityAlert;
	[superView addSubview:activityAlert.backgroundView];
	[activityAlert.backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
	[activityAlert.backgroundView addSubview:activityAlert];
	[activityAlert mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
	[activityAlert.backgroundView ht_whenTap:^(UIView *view) {
		[weakActivityAlert dismissWithAnimated:animated];
	}];
	activityAlert.contentImageView.image = backgroundImage;
	[activityAlert.contentImageView ht_whenTap:^(UIView *view) {
		[weakActivityAlert dismissWithAnimated:animated];
		HTWebController *webController = [[HTWebController alloc] initWithAddress:url];
		[superView.ht_controller.navigationController pushViewController:webController animated:true];
	}];
	[activityAlert.dismissCircleButton ht_whenTap:^(UIView *view) {
		[weakActivityAlert dismissWithAnimated:animated];
	}];
	[activityAlert startAnimation:animated show:true];
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
	[self addSubview:self.contentImageView];
	[self addSubview:self.dismissCircleButton];
	[self.contentImageView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.center.mas_equalTo(self);
//		make.width.mas_lessThanOrEqualTo(305).priority(999);
//		make.height.mas_lessThanOrEqualTo([UIScreen mainScreen].bounds.size.height - 300).priority(999);
	}];
	[self.dismissCircleButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.bottom.mas_equalTo(self.contentImageView.mas_top);
		make.left.mas_equalTo(self.contentImageView.mas_right);
	}];
}

- (UIView *)backgroundView {
	if (!_backgroundView) {
		_backgroundView = [[UIView alloc] init];
		_backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
	}
	return _backgroundView;
}

- (UIImageView *)contentImageView {
	if (!_contentImageView) {
		_contentImageView = [[UIImageView alloc] init];
		_contentImageView.contentMode = UIViewContentModeScaleToFill;
	}
	return _contentImageView;
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
