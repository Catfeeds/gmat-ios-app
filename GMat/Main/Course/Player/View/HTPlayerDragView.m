//
//  HTPlayerDragView.m
//  GMat
//
//  Created by hublot on 2017/9/26.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTPlayerDragView.h"

@interface HTPlayerDragView ()

@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@end

@implementation HTPlayerDragView

- (void)setPlayer:(AVPlayer *)player {
	if (self.playerLayer.player != player) {
		self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
		self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
		[self.layer addSublayer:self.playerLayer];
	}
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.layer.cornerRadius = MIN(self.bounds.size.width, self.bounds.size.height) / 2;
	self.playerLayer.frame = self.bounds;
}

- (void)setBeHalfHidden:(BOOL)beHalfHidden {
	_beHalfHidden = beHalfHidden;
	if (beHalfHidden) {
		self.playerLayer.hidden = true;
		self.backgroundColor = [UIColor clearColor];
		self.layer.masksToBounds = false;
	} else {
		self.playerLayer.hidden = false;
		self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
		self.layer.masksToBounds = true;
	}
}

@end
