//
//  HTSingleVersionForUserManager.h
//  GMat
//
//  Created by hublot on 17/9/14.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTQuestionManager.h"

@interface HTSingleVersionForUserManager : NSObject

+ (void)saveUserVersion:(HTSingleExerciseVersion)userVersion;

+ (HTSingleExerciseVersion)readUserVersion;

@end
