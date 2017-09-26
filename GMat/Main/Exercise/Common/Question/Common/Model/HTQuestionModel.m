//
//  HTQuestionModel.m
//  GMat
//
//  Created by hublot on 2016/11/18.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTQuestionModel.h"
#import "NSString+HTString.h"

@implementation HTQuestionModel

- (void)dealloc {
    
}

- (instancetype)initWithQuestionId:(NSString *)questionId questionRead:(NSString *)questionRead questionTitle:(NSString *)questionTitle storeQuestion:(BOOL)storeQuestion questionSelectedArray:(NSArray *)questionSelectedArray currentQuestionNumber:(NSInteger)currentQuestionNumber allQuestionCount:(NSInteger)allQuestionCount parseModelArray:(NSArray <HTQuestionParseModel *> *)parseModelArray {
	if (self = [super init]) {
		self.questionId = questionId;
		self.questionRead = questionRead;
		self.questionTitle = questionTitle;
		self.storeQuestion = storeQuestion;
		self.questionSelectedArray = questionSelectedArray;
		self.currentQuestionNumber = currentQuestionNumber;
		self.allQuestionCount = allQuestionCount;
		self.questionParseArray = parseModelArray;
	}
	return self;
}

- (NSArray<HTQuestionErrorModel *> *)errorModelArray {
	if (!_errorModelArray) {
		_errorModelArray = [HTQuestionErrorModel packModelArray];
	}
	return _errorModelArray;
}

@end
