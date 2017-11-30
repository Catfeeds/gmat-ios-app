//
//  HTCircleLabelAlert.m
//  GMat
//
//  Created by hublot on 2017/3/8.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTCircleLabelAlert.h"
#import "HTManagerController.h"

@interface HTCircleLabelAlert ()

@property (nonatomic, strong) NSTimer *hiddenTimer;

@end

static HTCircleLabelAlert *circleLabelAlert;


@implementation HTCircleLabelAlert

+ (instancetype)title:(NSString *)title superView:(UIView *)superView {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		circleLabelAlert = [[HTCircleLabelAlert alloc] init];
	});
	[circleLabelAlert.hiddenTimer invalidate];
	[circleLabelAlert.layer removeAllAnimations];
	circleLabelAlert.alpha = 1;
	circleLabelAlert.hiddenTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:[circleLabelAlert class] selector:@selector(dismissAlert) userInfo:nil repeats:false];
	[[NSRunLoop mainRunLoop] addTimer:circleLabelAlert.hiddenTimer forMode:NSRunLoopCommonModes];
	[superView addSubview:circleLabelAlert];
	circleLabelAlert.text = title;
	circleLabelAlert.frame = CGRectZero;
	[circleLabelAlert sizeToFit];
	if (circleLabelAlert.ht_w > HTSCREENWIDTH - 80) {
		circleLabelAlert.ht_w = HTSCREENWIDTH - 80;
		[circleLabelAlert sizeToFit];
	}
	circleLabelAlert.ht_w += 40;
	circleLabelAlert.ht_h += 16;
	circleLabelAlert.layer.cornerRadius = circleLabelAlert.ht_h / 2;
	circleLabelAlert.ht_y = 64;
	circleLabelAlert.ht_cx = [HTManagerController defaultManagerController].view.ht_w / 2;
	return circleLabelAlert;
}

+ (void)dismissAlert {
	[UIView animateWithDuration:2.5 animations:^{
		circleLabelAlert.alpha = 0;
	} completion:^(BOOL finished) {
		if (finished) {
			[circleLabelAlert removeFromSuperview];
		}
	}];
}

- (void)didMoveToSuperview {
	circleLabelAlert.backgroundColor = [UIColor whiteColor];
	circleLabelAlert.font = [UIFont systemFontOfSize:13];
	circleLabelAlert.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTheme];
	circleLabelAlert.textAlignment = NSTextAlignmentCenter;
	circleLabelAlert.layer.masksToBounds = true;
	circleLabelAlert.numberOfLines = 0;
}

@end
