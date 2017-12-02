//
//  HTVideoWiFIManager.h
//  GMat
//
//  Created by hublot on 2017/9/29.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTVideoWiFIManager : NSObject

+ (void)validateShouldPlayVideoWithComplete:(void(^)(BOOL shouldPlay))complete;

+ (BOOL)allowNotWiFiPlayVideo;

+ (void)setAllowNotWiFiPlayVideo:(BOOL)allowNotWiFiPlayVideo;

@end
