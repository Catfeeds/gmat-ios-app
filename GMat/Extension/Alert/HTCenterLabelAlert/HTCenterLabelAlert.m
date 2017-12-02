//
//  HTCenterLabelAlert.m
//  GMat
//
//  Created by hublot on 16/11/29.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTCenterLabelAlert.h"

@interface HTCenterLabelAlert ()

@property (nonatomic, strong) NSTimer *hiddenTimer;

@end

static HTCenterLabelAlert *centerLabelAlert;

@implementation HTCenterLabelAlert

+ (instancetype)title:(NSString *)title {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		centerLabelAlert = [[HTCenterLabelAlert alloc] init];
	});
	[centerLabelAlert.hiddenTimer invalidate];
	[centerLabelAlert.layer removeAllAnimations];
	centerLabelAlert.alpha = 1;
	centerLabelAlert.hiddenTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:[centerLabelAlert class] selector:@selector(dismissAlert) userInfo:nil repeats:false];
	[[NSRunLoop mainRunLoop] addTimer:centerLabelAlert.hiddenTimer forMode:NSRunLoopCommonModes];
	
	UIView *superView = [UIApplication sharedApplication].keyWindow;
	[superView addSubview:centerLabelAlert];
	centerLabelAlert.text = title;
	centerLabelAlert.frame = CGRectZero;
	[centerLabelAlert sizeToFit];
	if (centerLabelAlert.ht_w > HTSCREENWIDTH - HTADAPT568(60)) {
		centerLabelAlert.ht_w = HTSCREENWIDTH - HTADAPT568(60);
		[centerLabelAlert sizeToFit];
	}
	CGFloat width = centerLabelAlert.ht_w + HTADAPT568(40);
	CGFloat height = centerLabelAlert.ht_h + HTADAPT568(20);
	[centerLabelAlert mas_updateConstraints:^(MASConstraintMaker *make) {
		make.center.mas_equalTo(superView);
		make.width.mas_equalTo(width);
		make.height.mas_equalTo(height);
	}];
	return centerLabelAlert;
}

+ (void)dismissAlert {
	[UIView animateWithDuration:2.5 animations:^{
		centerLabelAlert.alpha = 0;
	} completion:^(BOOL finished) {
		if (finished) {
			[centerLabelAlert removeFromSuperview];
		}
	}];
}

- (void)didMoveToSuperview {
	centerLabelAlert.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
	centerLabelAlert.font = [UIFont ht_fontStyle:HTFontStyleTitleLarge];
	centerLabelAlert.textColor = [UIColor whiteColor];
	centerLabelAlert.textAlignment = NSTextAlignmentCenter;
	centerLabelAlert.layer.cornerRadius = 3;
	centerLabelAlert.layer.masksToBounds = true;
	centerLabelAlert.numberOfLines = 0;
}

@end
