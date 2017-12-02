//
//  HTQuestionModel.h
//  GMat
//
//  Created by hublot on 2016/11/18.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTGroupQuestionModel.h"
#import "HTQuestionParseModel.h"
#import "HTQuestionErrorModel.h"

@interface HTQuestionModel : NSObject

- (instancetype)initWithQuestionId:(NSString *)questionId questionRead:(NSString *)questionRead questionTitle:(NSString *)questionTitle storeQuestion:(BOOL)storeQuestion questionSelectedArray:(NSArray *)questionSelectedArray currentQuestionNumber:(NSInteger)currentQuestionNumber allQuestionCount:(NSInteger)allQuestionCount parseModelArray:(NSArray <HTQuestionParseModel *> *)parseModelArray;

@property (nonatomic, copy) NSString *questionId;

@property (nonatomic, copy) NSString *questionRead;

@property (nonatomic, copy) NSString *questionTitle;

@property (nonatomic, copy) NSString *plainQuestionTitle;

@property (nonatomic, assign, getter=isStoredQuestion) BOOL storeQuestion;


@property (nonatomic, strong) NSArray <NSString *> *questionSelectedArray;

@property (nonatomic, strong) NSArray <HTQuestionParseModel *> *questionParseArray;

@property (nonatomic, assign) NSInteger currentQuestionNumber;

@property (nonatomic, assign) NSInteger allQuestionCount;

@property (nonatomic, copy) NSString *trueAnswer;

@property (nonatomic, copy) NSString *userAnswer;

@property (nonatomic, copy) NSString *userSelectedAnswer;

@property (nonatomic, assign) NSInteger questionDuration;


@property (nonatomic, strong) NSArray <HTQuestionErrorModel *> *errorModelArray;

@property (nonatomic, strong) NSString *errorString;




@property (nonatomic, copy) NSString *questionNumber;

@end
