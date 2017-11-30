//
//  HTSingleVersionForUserManager.m
//  GMat
//
//  Created by hublot on 17/9/14.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTSingleVersionForUserManager.h"

@implementation HTSingleVersionForUserManager

static NSString *kHTSingleVersionForUserKey = @"kHTSingleVersionForUserKey";

+ (void)saveUserVersion:(HTSingleExerciseVersion)userVersion {
    [[NSUserDefaults standardUserDefaults] setValue:@(userVersion) forKey:kHTSingleVersionForUserKey];
}

+ (HTSingleExerciseVersion)readUserVersion {
    NSNumber *userVersion = [[NSUserDefaults standardUserDefaults] valueForKey:kHTSingleVersionForUserKey];
    if (!userVersion) {
        userVersion = @(HTSingleExerciseVersionNew);
    }
    return userVersion.integerValue;
}

@end
