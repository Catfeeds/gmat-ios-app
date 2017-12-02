//
//  HTActivityManager.m
//  GMat
//
//  Created by hublot on 2017/8/24.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTActivityManager.h"
#import "HTUserActionManager.h"
#import "HTManagerController.h"

@implementation HTActivityManager

static NSString *kHTActivityUserActionKey = @"id";

+ (BOOL)valiteShouldDisplayActivityWithActivityIdString:(NSString *)activityIdString maxDisplayCount:(NSInteger)maxDisplayCount {
	NSArray *keyValueArray = [HTUserActionManager trackKeyValueForType:HTUserActionTypeCompleteActivitySingle];
	__block NSInteger count = 0;
	[keyValueArray enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger index, BOOL * _Nonnull stop) {
		if ([[dictionary valueForKey:kHTActivityUserActionKey] isEqualToString:activityIdString]) {
			count ++;
		}
	}];
	if (count >= maxDisplayCount) {
		return false;
	}
	if ([HTManagerController defaultManagerController].managerModel.isDownloadFirstLaunch) {
		return false;
	}
	return true;
}

+ (void)appendActivityHistoryWithActivityIdString:(NSString *)activityIdString {
	NSDictionary *keyValue = @{kHTActivityUserActionKey:HTPlaceholderString(activityIdString, @"0")};
	[HTUserActionManager trackUserActionWithType:HTUserActionTypeCompleteActivityEveryone keyValue:keyValue];
	[HTUserActionManager trackUserActionWithType:HTUserActionTypeCompleteActivitySingle keyValue:keyValue];
}

@end
