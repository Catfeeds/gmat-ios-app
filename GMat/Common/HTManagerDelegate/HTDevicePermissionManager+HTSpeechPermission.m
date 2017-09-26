//
//  HTDevicePermissionManager+HTSpeechPermission.m
//  GMat
//
//  Created by hublot on 17/5/27.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTDevicePermissionManager+HTSpeechPermission.h"
#import <Speech/Speech.h>

@implementation HTDevicePermissionManager (HTSpeechPermission)

+ (void)ht_sureSpeechRecognizerAuthorized:(void(^)(void))authorized openUrlBlock:(void(^)(void))openUrlBlock everDenied:(void(^)(void(^openUrlBlock)(void)))everDenied nowDenied:(void(^)(void(^openUrlBlock)(void)))nowDenied restricted:(void(^)(void))restricted {
    
    #ifdef __IPHONE_10_0
    
        openUrlBlock = ^() {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        };
    
        SFSpeechRecognizerAuthorizationStatus status = [SFSpeechRecognizer authorizationStatus];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             switch (status) {
                 case SFSpeechRecognizerAuthorizationStatusNotDetermined: {
                 // 还没有询问过此权限, 用户还未做出决定
                 
                 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                     [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            if (status == SFSpeechRecognizerAuthorizationStatusAuthorized) {
                                if (authorized) {
                                    authorized();
                                }
                            } else if (status == SFSpeechRecognizerAuthorizationStatusDenied) {
                                if (nowDenied) {
                                    nowDenied(openUrlBlock);
                                }
                            }
                        }];
                     }];
                 }];
                     break;
                 }
                 case SFSpeechRecognizerAuthorizationStatusAuthorized: {
                     // 已经同意过了
                     if (authorized) {
                         authorized();
                     }
                     break;
                 }
                 case SFSpeechRecognizerAuthorizationStatusDenied: {
                     // 已经拒绝过了
                     if (everDenied) {
                         everDenied(openUrlBlock);
                     }
                     break;
                 }
                 case SFSpeechRecognizerAuthorizationStatusRestricted: {
                     // 例如家长控制的情况, 所以用户无法更改
                     if (restricted) {
                         restricted();
                     }
                     break;
                 }
             }
        }];
    #endif
}

@end
