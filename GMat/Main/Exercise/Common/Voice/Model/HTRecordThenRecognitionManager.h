//
//  HTRecordThenRecognitionManager.h
//  GMat
//
//  Created by hublot on 2017/4/12.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTRecordThenRecognitionManager : NSObject

@property (nonatomic, strong) void(^recognitionReplyBlock)(NSString *totalRecognitionString, BOOL isFinally);

@property (nonatomic, assign) BOOL isRecordAndRecognition;

@end
