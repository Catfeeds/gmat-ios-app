//
//  HTPlayerView+HTSwitch.m
//  GMat
//
//  Created by hublot on 2017/9/28.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTPlayerView+HTSwitch.h"
#import "HTPlayerView+HTView.h"
#import "HTPlayerView+HTTouch.h"
#import <AFNetworkReachabilityManager.h>
#import "HTVideoWiFIManager.h"
#import "HTManagerController+HTRotate.h"

@interface HTPlayerView ()

@end

@implementation HTPlayerView (HTSwitch)

- (void)switchClearScrrenWithAnimated:(BOOL)animated {
	BOOL willClear = false;
	if (self.isPortrait) {
		willClear = self.toolBar.alpha > 0;
	} else {
		willClear = (CGAffineTransformEqualToTransform(self.navigationBar.transform, CGAffineTransformIdentity) ||
					 CGAffineTransformEqualToTransform(self.playerTabBar.transform, CGAffineTransformIdentity) ||
					 CGAffineTransformEqualToTransform(self.playerLeftBar.transform, CGAffineTransformIdentity));
	}
	[self switchClearScrrenWithAnimated:animated willClear:willClear];
}

- (void)switchClearScrrenWithAnimated:(BOOL)animated willClear:(BOOL)willClear {
	self.willClearAnimated = animated;
	self.willClearScreen = willClear;
	[self switchClearScrren];
}

- (void)switchClearScrren {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchClearScrren) object:nil];
	if (self.isHighlighted) {
		self.willClearAnimated = false;
		self.willClearScreen = false;
	}
	if (self.isShowConfigureView) {
		self.willClearAnimated = true;
		self.willClearScreen = true;
	}
	[UIView animateWithDuration:self.willClearAnimated ? 0.25 : 0 animations:^{
		if (self.isPortrait) {
			if (self.willClearScreen) {
				self.toolBar.alpha = 0;
			} else {
				self.toolBar.alpha = 1;
			}
			[[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationSlide];
		} else {
			if (self.willClearScreen) {
				self.navigationBar.transform = CGAffineTransformMakeTranslation(0, - (self.navigationBar.ht_h));
				self.playerTabBar.transform = CGAffineTransformMakeTranslation(0, self.playerTabBar.ht_h);
				self.playerLeftBar.transform = CGAffineTransformMakeTranslation(- self.playerLeftBar.ht_w, 0);
				[[UIApplication sharedApplication] setStatusBarHidden:true withAnimation:UIStatusBarAnimationSlide];
			} else {
				if (!self.isLockPlayer) {
					self.navigationBar.transform = CGAffineTransformIdentity;
					self.playerTabBar.transform = CGAffineTransformIdentity;
				}
				self.playerLeftBar.transform = CGAffineTransformIdentity;
				[[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationSlide];
			}
		}
		
		if (!self.willClearScreen) {
			self.willClearAnimated = true;
			self.willClearScreen = true;
			[self performSelector:@selector(switchClearScrren) withObject:nil afterDelay:3];
		}
	} completion:^(BOOL finished) {
		
	}];
}

- (void)shouldStartLoading:(BOOL)loading {
	if (loading) {
		[self.loadIndicatorView startAnimating];
	} else {
		[self.loadIndicatorView stopAnimating];
	}
}

- (void)playerModelDidPlayEnd:(AVPlayerItem *)item {
	self.playerModel.dragEndTime = 0;
	[self.playerModel reloadWillSeekRateWillPlay:false];
}

- (void)networkStateDidChange {
	if ([AFNetworkReachabilityManager sharedManager].reachableViaWiFi == false) {
		[self.playerModel reloadWillSeekRateWillPlay:false];
		[HTVideoWiFIManager validateShouldPlayVideoWithComplete:^(BOOL shouldPlay) {
			[self.playerModel reloadWillSeekRateWillPlay:shouldPlay];
			if (!shouldPlay) {
				[HTManagerController setDeviceOrientation:UIDeviceOrientationPortrait];
				[self.ht_controller.navigationController popViewControllerAnimated:true];
			}
		}];
	}
}

- (void)switchConfigureViewHidden:(BOOL)hidden animated:(BOOL)animated {
	[UIView animateWithDuration:animated ? 0.25 : 0 animations:^{
		if (!hidden) {
			self.configureView.transform = CGAffineTransformMakeTranslation(- self.configureView.ht_w, 0);
		} else {
			[self.configureView showView:nil];
			self.configureView.transform = CGAffineTransformIdentity;
		}
	} completion:^(BOOL finished) {
		
	}];
}

@end
