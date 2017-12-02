//
//  HTVideoWiFIManager.m
//  GMat
//
//  Created by hublot on 2017/9/29.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTVideoWiFIManager.h"

@implementation HTVideoWiFIManager

static NSString *kHTVideoAllowNotWIFIKey = @"kHTVideoAllowNotWIFIKey";

+ (void)validateShouldPlayVideoWithComplete:(void(^)(BOOL shouldPlay))complete {
	if (!complete) {
		return;
	}
	if ([self allowNotWiFiPlayVideo]) {
		complete(true);
		return;
	} else {
		[HTAlert title:@"正在使用非 WIFI 播放视频, 可能会产生流量费用, 是否打开开关" message:nil sureAction:^{
			[self setAllowNotWiFiPlayVideo:true];
			complete(true);
		} cancelAction:^{
			complete(false);
		} animated:true completion:nil];
	}
}

+ (BOOL)allowNotWiFiPlayVideo {
	return [[[NSUserDefaults standardUserDefaults] valueForKey:kHTVideoAllowNotWIFIKey] boolValue];
}

+ (void)setAllowNotWiFiPlayVideo:(BOOL)allowNotWiFiPlayVideo {
	[[NSUserDefaults standardUserDefaults] setValue:@(allowNotWiFiPlayVideo) forKey:kHTVideoAllowNotWIFIKey];
}

@end
