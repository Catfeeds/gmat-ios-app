//
//  HTDevicePermissionManager+HTSpeechPermission.h
//  GMat
//
//  Created by hublot on 17/5/27.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <HTDevicePermissionManager.h>

@interface HTDevicePermissionManager (HTSpeechPermission)

+ (void)ht_sureSpeechRecognizerAuthorized:(void(^)(void))authorized openUrlBlock:(void(^)(void))openUrlBlock everDenied:(void(^)(void(^openUrlBlock)(void)))everDenied nowDenied:(void(^)(void(^openUrlBlock)(void)))nowDenied restricted:(void(^)(void))restricted;

@end
