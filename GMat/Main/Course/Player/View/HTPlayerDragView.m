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

- (void)dealloc {

}

- (void)setPlayer:(AVPlayer *)player {
	if (self.playerLayer.player != player) {
		self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
		self.playerLayer.videoGravity = AVLayerVideoGravityResize;
		self.playerLayer.masksToBounds = true;
		[self.layer addSublayer:self.playerLayer];
	}
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.playerLayer.frame = self.bounds;
}

@end
