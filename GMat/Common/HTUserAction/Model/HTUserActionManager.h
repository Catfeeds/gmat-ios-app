//
//  HTUserActionManager.h
//  GMat
//
//  Created by hublot on 2017/8/4.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kHTUserActionAppendNotification;

typedef NS_ENUM(NSInteger, HTUserActionType) {
	HTUserActionTypeCompleteSingleQuestion = 1001,
	HTUserActionTypeCompleteSingleMock,
	HTUserActionTypeCompleteActivityEveryone,
	HTUserActionTypeCompleteActivitySingle,
};

@interface HTUserActionManager : NSObject

+ (void)trackUserActionWithType:(HTUserActionType)type keyValue:(NSDictionary *)keyValue;

+ (NSInteger)trackCountForType:(HTUserActionType)type;

+ (NSArray <NSDictionary *> *)trackKeyValueForType:(HTUserActionType)type;

@end
