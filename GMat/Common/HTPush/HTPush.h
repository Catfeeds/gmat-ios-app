//
//  HTPush.h
//  GMat
//
//  Created by hublot on 2016/11/24.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTPush : NSObject

+ (void)didReceiveRemoteNotification:(NSDictionary *)userInfo;

+ (void)didReceiveRemoteMessage:(NSDictionary *)message;

+ (void)saveAliasWithUid:(NSString *)uidString loginIdentifier:(NSString *)loginIdentifier;

@end
