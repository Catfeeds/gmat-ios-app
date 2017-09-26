//
//  HTUserManager.h
//  GMat
//
//  Created by hublot on 2017/5/25.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTUser.h"



extern NSString *const kuserTableName;

extern NSString *const kuserExerciseRecordTableName;

extern NSString *const kuserExerciseStoryTableName;



@interface HTUserManager : NSObject

+ (NSString *)userManagerSqlitePath;





+ (void)saveToUserTableWithUser:(HTUser *)user;

+ (HTUser *)currentUser;

+ (void)updateUserDetailComplete:(void(^)(BOOL success))complete;

+ (void)surePermissionHighOrEqual:(HTUserPermission)permission passCompareBlock:(void(^)(HTUser *user))passCompareBlock;





+ (void)updateUserDetailComplete:(void(^)(BOOL success))complete userLoginDictionary:(NSDictionary *)userLoginDictionary;


+ (instancetype)defaultUserManager;

@property (nonatomic, assign) BOOL synchronousExerciseRecord;

- (void)startSynchronousExerciseRecordCompleteHandleBlock:(void(^)(NSString *errorString))completeHandleBlock;

@end
