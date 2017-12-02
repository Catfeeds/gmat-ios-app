//
//  HTExerciseWrongRecordModel.h
//  GMat
//
//  Created by hublot on 2016/11/1.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTRecordExerciseModel : NSObject

@property (nonatomic, copy) NSString *section;

@property (nonatomic, copy) NSString *questionId;

@property (nonatomic, copy) NSString *userAnswer;

@property (nonatomic, copy) NSString *rightAnswer;

@property (nonatomic, copy) NSString *questionTitle;

@property (nonatomic, copy) NSString *submitTime;

@property (nonatomic, copy) NSString *duration;

@property (nonatomic, copy) NSString *num;

@end
