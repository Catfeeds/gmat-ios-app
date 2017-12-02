//
//  HTQuestionManager.h
//  GMat
//
//  Created by hublot on 2017/2/27.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "HTExerciseModel.h"
#import "HTQuestionModel.h"
#import "HTRecordModel.h"
#import "HTUserManager.h"
#import "HTScoreModel.h"
#import "HTStoreModel.h"
#import "HTRecordExerciseModel.h"

typedef NS_ENUM(NSInteger, HTSingleExerciseVersion) {
    HTSingleExerciseVersionAll = - 1,
    HTSingleExerciseVersionOld = 0,
    HTSingleExerciseVersionNew = 1,
};

@interface HTQuestionManager : NSObject

+ (NSMutableArray <HTExerciseModel *> *)packExerciseModelArrayWithSectionId:(NSString *)sectionId twoObjectIdArray:(NSArray <NSString *> *)twoObjectIdArray singleExerciseVersion:(HTSingleExerciseVersion)singleExerciseVersion;

+ (NSMutableArray <HTExerciseModel *> *)packExerciseModelArrayWithSectionId:(NSString *)sectionId levelId:(NSString *)levelId;

+ (NSMutableArray <HTExerciseModel *> *)packExerciseModelArrayWithSectionId:(NSString *)sectionId twoObjectIdArray:(NSArray <NSString *> *)twoObjectIdArray levelId:(NSString *)levelId singleExerciseVersion:(HTSingleExerciseVersion)singleExerciseVersion;

+ (NSMutableArray <HTExerciseModel *> *)packPointExerciseModelArrayWithSectionId:(NSString *)sectionId;

+ (NSMutableArray <HTExerciseModel *> *)packExerciseModelArrayWithKnowsid:(NSString *)knowsid;

+ (NSMutableArray <HTExerciseModel *> *)packSortExerciseModelArrayWithSectionId:(NSString *)sectionId twoObjectIdArray:(NSArray <NSString *> *)twoObjectIdArray;


+ (HTExerciseModel *)packExerciseModelWithStid:(NSString *)stid;



+ (void)packQuestionModelWithExerciseModel:(HTExerciseModel *)exerciseModel startPackBlock:(void(^)(void))startPackBlock completePackBlock:(void(^)(HTQuestionModel *questionModel))completePackBlock;

//+ (void)packQuestionToAutoExerciseWithstartPackBlock:(void(^)(void))startPackBlock completePackBlock:(void(^)(HTQuestionModel *questionModel))completePackBlock;

+ (void)packQuestionModelWithQuestionId:(NSString *)questionId startPackBlock:(void(^)(void))startPackBlock completePackBlock:(void(^)(HTQuestionModel *questionModel))completePackBlock;

+ (void)insertQuestionRecordWithQuestionId:(NSString *)questionId exerciseModel:(HTExerciseModel *)exerciseModel questionDuration:(NSString *)questionDuration questionUserAnswer:(NSString *)questionUserAnswer startPackBlock:(void(^)(void))startPackBlock completePackBlock:(void(^)(BOOL success))completePackBlock;


+ (BOOL)isStoredWithQuestionId:(NSString *)questionId;

+ (void)switchStoreStateWithQuestionId:(NSString *)questionId;



+ (void)packScoreModelWithExerciseModel:(HTExerciseModel *)exerciseModel startPackBlock:(void(^)(void))startPackBlock completePackBlock:(void(^)(HTScoreModel *scoreModel))completePackBlock;

+ (void)packQuestionModelArrayWithExerciseModel:(HTExerciseModel *)exerciseModel startPackBlock:(void(^)(void))startPackBlock completePackBlock:(void(^)(NSArray <HTQuestionModel *> *questionModelArray))completePackBlock;

+ (void)cleanQuestionModelArrayWithExerciseModel:(HTExerciseModel *)exerciseModel;



+ (NSString *)sectionTitleWithSectionId:(NSInteger)sectionId;

+ (NSString *)twoobjectTitlteWithTwoobjectId:(NSInteger)twoobjectId;


+ (NSString *)findUserNearStid;

+ (NSString *)detailStringWithStid:(NSString *)stid;

//获取所有做题记录
+ (NSString *)sumUserAllExerciseRecordCount;

//获取今日做题
+ (NSString *)sumUserTodayExerciseRecordCount;

//获取用户答案
+ (NSString *)getUserAnswerWithQuestionID:(NSString *)questionID;

+ (NSString *)userAllExerciseCorrect;

+ (NSMutableArray <HTStoreModel *> *)packStoreItemWithSectionId:(NSString *)sectionId twoObjectIdArray:(NSArray <NSString *> *)twoObjectIdArray currentPage:(NSString *)currentPage pageCount:(NSString *)pageCount;


+ (NSMutableArray <HTRecordExerciseModel *> *)packExerciseModelWithSectionId:(NSString *)sectionId currentPage:(NSString *)currentPage pageCount:(NSString *)pageCount onlyNeedWrong:(BOOL)onlyNeedWrong;

+ (NSArray <HTQuestionParseModel *> *)packParseModelArrayWithQuestionId:(NSString *)questionId;


+ (void)synchronousStartHandleBlock:(void(^)(void))startHandleBlock completeHandleBlock:(void(^)(NSString *errorString))completeHandleBlock;

+ (void)searchWithKeyword:(NSString *)keyword pageNumber:(NSString *)pageNumber pageSize:(NSString *)pageSize complete:(void(^)(NSArray <HTQuestionModel *> *searchQuestionModelArray))complete;

+ (BOOL)updateSqliteTableName:(NSString *)tableName dataBase:(FMDatabase *)dataBase dictionary:(NSDictionary *)dictionary primaryKey:(NSString *)primaryKey;


+ (NSString *)localSqliteLastUpdateTime;

+ (void)setLocalSqliteLastUpdateTime:(NSString *)time;

+ (void)downloadUpdateSqliteStartHandleBlock:(void (^)(void))startHandleBlock progressHandleBlock:(HTUserTaskProgressBlock)progressHandleBlock completeHandleBlock:(void (^)(NSString *))completeHandleBlock;

@end
