//
//  HTPlayerConfigureView.m
//  GMat
//
//  Created by hublot on 2017/9/28.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTPlayerConfigureView.h"

@implementation HTPlayerConfigureView

- (void)dealloc {
	
}

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
}

- (void)showView:(UIView *)view {
	while (self.subviews.count) {
		[self.subviews.lastObject removeFromSuperview];
	}
	if (view) {
		[self addSubview:view];
	}
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.subviews.lastObject.frame = self.bounds;
}

@end
