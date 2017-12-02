//
//  HTUser.m
//  GMat
//
//  Created by hublot on 2017/5/25.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTUser.h"
#import "HTQuestionManager.h"

@implementation HTUser

- (HTUserPermission)permission {
	if (self.phone.length || self.useremail.length) {
		return HTUserPermissionExerciseAbleUser;
//	} else if (self.username.length) {
//		return HTUserPermissionExerciseNotFullThreeUser;
	} else if (self.num.integerValue < 5) {
		return HTUserPermissionExerciseAbleVisitor;
	} else {
		return HTUserPermissionExerciseUnAbleVisitor;
	}
}

- (NSString *)num {
	return [HTQuestionManager sumUserAllExerciseRecordCount];
}

- (NSString *)accuracy {
	return [HTQuestionManager userAllExerciseCorrect];
}

- (NSString *)user_tikuname {
	return [HTQuestionManager detailStringWithStid:self.nearExerciseStid];
}

- (NSString *)nearExerciseStid {
	return [HTQuestionManager findUserNearStid];
}

@end
