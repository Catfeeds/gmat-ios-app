//
//  HTActivityManager.h
//  GMat
//
//  Created by hublot on 2017/8/24.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTActivityManager : NSObject

+ (BOOL)valiteShouldDisplayActivityWithActivityIdString:(NSString *)activityIdString maxDisplayCount:(NSInteger)maxDisplayCount;

+ (void)appendActivityHistoryWithActivityIdString:(NSString *)activityIdString;

@end
