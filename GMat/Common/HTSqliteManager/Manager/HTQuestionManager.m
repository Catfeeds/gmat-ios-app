//
//  HTQuestionManager.m
//  GMat
//
//  Created by hublot on 2017/2/27.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTQuestionManager.h"
#import "NSString+HTString.h"
#import <HTEncodeDecodeManager.h>
#import <HTRandomNumberManager.h>
#import "RNDecryptor.h"
#import "HTSqliteUpdateModel.h"

static NSOperationQueue *searchOperationQueue;

static NSString *kHTLocalSqliteLastUpdateTimeKey = @"kHTLocalSqliteLastUpdateTimeKey";

@implementation HTQuestionManager

+ (NSString *)questionManagerSqlitePath {
    NSString *entryFilePath = [[NSBundle mainBundle] pathForAuxiliaryExecutable:@"gmat.11"];
    NSString *detryFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject] stringByAppendingPathComponent:@"gmat_11.sqlite"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:detryFilePath]) {
        NSData *entryFileData = [NSData dataWithContentsOfFile:entryFilePath];
        NSString *password = @"3500898687@qq.com";
		NSData *detryFileData = [RNDecryptor decryptData:entryFileData withPassword:password error:nil];
        [detryFileData writeToFile:detryFilePath atomically:true];
	}
    return detryFilePath;
}

+ (NSMutableArray <HTExerciseModel *> *)packExerciseModelArrayWithSectionId:(NSString *)sectionId twoObjectIdArray:(NSArray <NSString *> *)twoObjectIdArray singleExerciseVersion:(HTSingleExerciseVersion)singleExerciseVersion {
	return [self packExerciseModelArrayWithSectionId:sectionId twoObjectIdArray:twoObjectIdArray levelId:@"" singleExerciseVersion:singleExerciseVersion];
}

+ (NSMutableArray <HTExerciseModel *> *)packExerciseModelArrayWithSectionId:(NSString *)sectionId levelId:(NSString *)levelId {
    return [self packExerciseModelArrayWithSectionId:sectionId twoObjectIdArray:nil levelId:levelId singleExerciseVersion:HTSingleExerciseVersionAll];
}

+ (NSMutableArray <HTExerciseModel *> *)packExerciseModelArrayWithSectionId:(NSString *)sectionId twoObjectIdArray:(NSArray <NSString *> *)twoObjectIdArray levelId:(NSString *)levelId singleExerciseVersion:(HTSingleExerciseVersion)singleExerciseVersion {
    FMDatabase *questionDataBase = [FMDatabase databaseWithPath:[self questionManagerSqlitePath]];
    NSMutableArray <HTExerciseModel *> *modelArray = [@[] mutableCopy];
    if ([questionDataBase open]) {
        FMResultSet *questionResultSet;
		NSString *selecteSqliteString;
        if (twoObjectIdArray.count) {
			NSMutableString *twoobjectArrayString = [@"(" mutableCopy];
			[twoObjectIdArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
				if (idx < twoObjectIdArray.count - 1) {
					[twoobjectArrayString appendFormat:@"%@, ", obj];
				} else {
					[twoobjectArrayString appendFormat:@"%@)", obj];
				}
			}];
			selecteSqliteString = [NSString stringWithFormat:@"select * from \"x2_lower_tiku\" where sectionid = %@ and twoobjectid in %@", [NSString stringWithFormat:@"%@", sectionId], [NSString stringWithFormat:@"%@", twoobjectArrayString]];
        } else if (levelId.length) {
			selecteSqliteString = [NSString stringWithFormat:@"select * from \"x2_lower_tiku\" where sectionid = %@ and levelId = %@", [NSString stringWithFormat:@"%@", sectionId], [NSString stringWithFormat:@"%@", levelId]];
        }
        switch (singleExerciseVersion) {
            case HTSingleExerciseVersionAll: {
                break;
            }
            case HTSingleExerciseVersionOld: {
                selecteSqliteString = [NSString stringWithFormat:@"%@ and type == %ld", selecteSqliteString, HTSingleExerciseVersionOld];
                break;
            }
            case HTSingleExerciseVersionNew: {
                selecteSqliteString = [NSString stringWithFormat:@"%@ and type == %ld", selecteSqliteString, HTSingleExerciseVersionNew];
                break;
            }
        }
		questionResultSet = [questionDataBase executeQuery:selecteSqliteString];
        while (questionResultSet.next) {
            HTExerciseModel *exerciseModel = [[HTExerciseModel alloc] init];
            exerciseModel.knowsid = [questionResultSet stringForColumn:@"knowsid"];
            exerciseModel.questionsid = [questionResultSet stringForColumn:@"questionsid"];
            NSArray *questionIdArray = [exerciseModel.questionsid componentsSeparatedByString:@","];
            exerciseModel.lowertknumb = questionIdArray.count;
            exerciseModel.sectionid = [questionResultSet stringForColumn:@"sectionid"];
            exerciseModel.twoobjectid = [questionResultSet stringForColumn:@"twoobjectid"];
            exerciseModel.stid = [questionResultSet stringForColumn:@"stid"];
            exerciseModel.stname = [questionResultSet stringForColumn:@"stname"];
            exerciseModel.subjectid = [questionResultSet stringForColumn:@"subjectid"];
            exerciseModel.userlowertk = @"0";
            exerciseModel.correct = arc4random_uniform(12) + 60;
            
            FMDatabase *recordDataBase = [FMDatabase databaseWithPath:[HTUserManager userManagerSqlitePath]];
            if ([recordDataBase open]) {
                FMResultSet *exerciseResultSet = [recordDataBase executeQuery:[NSString stringWithFormat:@"select * from %@ where stid = ? and userid = ? and exerciseState = 1", kuserExerciseRecordTableName], exerciseModel.stid, [HTUserManager currentUser].userid];
				while (exerciseResultSet.next) {
					exerciseModel.userlowertk = [NSString stringWithFormat:@"%ld", MIN(exerciseModel.userlowertk.integerValue + 1, exerciseModel.lowertknumb)];
				}
                [recordDataBase close];
            }
            [modelArray addObject:exerciseModel];
        }
        [questionDataBase close];
    }
    return modelArray;
}

+ (NSMutableArray <HTExerciseModel *> *)packSortExerciseModelArrayWithSectionId:(NSString *)sectionId twoObjectIdArray:(NSArray <NSString *> *)twoObjectIdArray {
	FMDatabase *questionDataBase = [FMDatabase databaseWithPath:[self questionManagerSqlitePath]];
	NSMutableArray <HTExerciseModel *> *exerciseModelArray = [@[] mutableCopy];
	if ([questionDataBase open]) {
		NSMutableString *twoobjectArrayString = [@"(" mutableCopy];
		[twoObjectIdArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			if (idx < twoObjectIdArray.count - 1) {
				[twoobjectArrayString appendFormat:@"%@, ", obj];
			} else {
				[twoobjectArrayString appendFormat:@"%@)", obj];
			}
		}];
		NSString *selecteSortExerciseString = [NSString stringWithFormat:@"select * from \"x2_xuhao_tiku\" where section = %@ and twoobject in %@", [NSString stringWithFormat:@"%@", sectionId], [NSString stringWithFormat:@"%@", twoobjectArrayString]];
		FMResultSet *sortExerciseResultSet = [questionDataBase executeQuery:selecteSortExerciseString];
		while (sortExerciseResultSet.next) {
			HTExerciseModel *exerciseModel = [[HTExerciseModel alloc] init];
			exerciseModel.stid = @"0";
			exerciseModel.xuhaotikuId = [sortExerciseResultSet stringForColumn:@"id"];
			exerciseModel.modelStyle = HTExerciseModelStyleSort;
			exerciseModel.sectionid = [sortExerciseResultSet stringForColumn:@"section"];
			exerciseModel.twoobjectid = [sortExerciseResultSet stringForColumn:@"twoobject"];
			exerciseModel.stname = [sortExerciseResultSet stringForColumn:@"number"];
			exerciseModel.correct = arc4random_uniform(12) + 60;
			
			NSString *selecteSortQuestionString = [NSString stringWithFormat:@"select questionid from \"x2_xuhao_question\" where tikuId = %@", exerciseModel.xuhaotikuId];
			FMResultSet *sortQuestionResultSet = [questionDataBase executeQuery:selecteSortQuestionString];
			NSMutableArray *questionModelArray = [@[] mutableCopy];
			while (sortQuestionResultSet.next) {
				NSString *questionIdString = [sortQuestionResultSet stringForColumn:@"questionid"];
                NSString *questionNumberString = [questionDataBase stringForQuery:@"select questionNumber from \"x2_questions\" where questionid = ?", questionIdString];
				HTQuestionModel *questionModel = [[HTQuestionModel alloc] init];
                questionModel.questionId = questionIdString;
                questionModel.questionNumber = questionNumberString;
				if (questionModel.questionId.length) {
					[questionModelArray addObject:questionModel];
				}
			}
			[questionModelArray sortUsingComparator:^NSComparisonResult(HTQuestionModel *thisQuestionModel, HTQuestionModel *thatQuestionModel) {
				return [thisQuestionModel.questionNumber compare:thatQuestionModel.questionNumber];
			}];
			if (questionModelArray.count) {
				NSMutableArray *questionIdArray = [@[] mutableCopy];
				[questionModelArray enumerateObjectsUsingBlock:^(HTQuestionModel *questionModel, NSUInteger idx, BOOL * _Nonnull stop) {
					[questionIdArray addObject:questionModel.questionId];
				}];
				NSString *questionIdString = [questionIdArray componentsJoinedByString:@","];
				exerciseModel.questionsid = questionIdString;
				exerciseModel.lowertknumb = questionIdArray.count;
				
				
				exerciseModel.userlowertk = @"0";
				FMDatabase *exerciseRecordDataBase = [FMDatabase databaseWithPath:[HTUserManager userManagerSqlitePath]];
				if ([exerciseRecordDataBase open]) {
					FMResultSet *exerciseRecordResultSet = [exerciseRecordDataBase executeQuery:[NSString stringWithFormat:@"select * from %@ where xuhaotikuId = ? and userid = ? and exerciseState = 1", kuserExerciseRecordTableName], exerciseModel.xuhaotikuId, [HTUserManager currentUser].userid];
					while (exerciseRecordResultSet.next) {
						exerciseModel.userlowertk = [NSString stringWithFormat:@"%ld", MIN(exerciseModel.userlowertk.integerValue + 1, exerciseModel.lowertknumb)];
					}
					[exerciseRecordDataBase close];
				}

				[exerciseModelArray addObject:exerciseModel];
			}
		}
	}
	return exerciseModelArray;
}

+ (NSMutableArray <HTExerciseModel *> *)packPointExerciseModelArrayWithSectionId:(NSString *)sectionId {
    FMDatabase *questionDataBase = [FMDatabase databaseWithPath:[self questionManagerSqlitePath]];
    NSMutableArray <HTExerciseModel *> *modelArray = [@[] mutableCopy];
    if ([questionDataBase open]) {
        FMResultSet *konwsResultSet = [questionDataBase executeQuery:@"select * from \"x2_knows\" where knowssectionid = ? and knowsstatus = ?", sectionId, @"1"];
        while (konwsResultSet.next) {
            HTExerciseModel *exerciseModel = [[HTExerciseModel alloc] init];
            exerciseModel.knows = [konwsResultSet stringForColumn:@"knows"];
            exerciseModel.knowsid = [konwsResultSet stringForColumn:@"knowsid"];
            FMResultSet *lowerResultSet = [questionDataBase executeQuery:@"select * from \"x2_lower_tiku\" where knowsid = ?", exerciseModel.knowsid];
            while (lowerResultSet.next) {
                NSString *questionsId = [lowerResultSet stringForColumn:@"questionsid"];
                NSArray *questionArray = [questionsId componentsSeparatedByString:@","];
                exerciseModel.lowertknumb += questionArray.count;
            }
            exerciseModel.num = [HTRandomNumberManager ht_randomIntegerWithIdentifier:[NSString stringWithFormat:@"HTExerciseCount%@", exerciseModel.knows] minBeginCount:3000 maxBeginCount:3500 minAppendCount:200 maxAppendCount:350 spendHour:24];
			if (exerciseModel.lowertknumb > 0) {
				[modelArray addObject:exerciseModel];
			}
        }
        [questionDataBase close];
    }
    return modelArray;
}

+ (NSMutableArray <HTExerciseModel *> *)packExerciseModelArrayWithKnowsid:(NSString *)knowsid {
    FMDatabase *questionDataBase = [FMDatabase databaseWithPath:[self questionManagerSqlitePath]];
    NSMutableArray <HTExerciseModel *> *modelArray = [@[] mutableCopy];
    if ([questionDataBase open]) {
        FMResultSet *lowerResultSet = [questionDataBase executeQuery:@"select * from \"x2_lower_tiku\" where knowsid = ?", knowsid];
        while (lowerResultSet.next) {
            HTExerciseModel *exerciseModel = [[HTExerciseModel alloc] init];
            exerciseModel.knowsid = [lowerResultSet stringForColumn:@"knowsid"];
            exerciseModel.questionsid = [lowerResultSet stringForColumn:@"questionsid"];
            NSArray *questionIdArray = [exerciseModel.questionsid componentsSeparatedByString:@","];
            exerciseModel.lowertknumb = questionIdArray.count;
            exerciseModel.sectionid = [lowerResultSet stringForColumn:@"sectionid"];
            exerciseModel.twoobjectid = [lowerResultSet stringForColumn:@"twoobjectid"];
            exerciseModel.stid = [lowerResultSet stringForColumn:@"stid"];
            exerciseModel.stname = [lowerResultSet stringForColumn:@"stname"];
            exerciseModel.subjectid = [lowerResultSet stringForColumn:@"subjectid"];
            exerciseModel.userlowertk = @"0";
            exerciseModel.correct = arc4random_uniform(12) + 60;
            exerciseModel.num = [HTRandomNumberManager ht_randomIntegerWithIdentifier:[NSString stringWithFormat:@"HTExerciseCount%@", exerciseModel.stid] minBeginCount:100 maxBeginCount:600 minAppendCount:10 maxAppendCount:15 spendHour:24];

            exerciseModel.meanTime = arc4random_uniform(30) + 30;
            
            FMDatabase *recordDataBase = [FMDatabase databaseWithPath:[HTUserManager userManagerSqlitePath]];
            if ([recordDataBase open]) {
                FMResultSet *exerciseResultSet = [recordDataBase executeQuery:[NSString stringWithFormat:@"select * from %@ where stid = ? and userid = ? and exerciseState = 1", kuserExerciseRecordTableName], exerciseModel.stid, [HTUserManager currentUser].userid];
				while (exerciseResultSet.next) {
					exerciseModel.userlowertk = [NSString stringWithFormat:@"%ld", MIN(exerciseModel.userlowertk.integerValue + 1, exerciseModel.lowertknumb)];
				}
                [recordDataBase close];
            }
            [modelArray addObject:exerciseModel];
        }
        [questionDataBase close];
    }
    return modelArray;
}

+ (HTExerciseModel *)packExerciseModelWithStid:(NSString *)stid {
    FMDatabase *questionDataBase = [FMDatabase databaseWithPath:[self questionManagerSqlitePath]];
    HTExerciseModel *exerciseModel;
    if ([questionDataBase open]) {
        FMResultSet *lowerResultSet = [questionDataBase executeQuery:@"select * from \"x2_lower_tiku\" where stid = ?", stid];
        if (lowerResultSet.next) {
            exerciseModel = [[HTExerciseModel alloc] init];
            exerciseModel.knowsid = [lowerResultSet stringForColumn:@"knowsid"];
            exerciseModel.questionsid = [lowerResultSet stringForColumn:@"questionsid"];
            NSArray *questionIdArray = [exerciseModel.questionsid componentsSeparatedByString:@","];
            exerciseModel.lowertknumb = questionIdArray.count;
            exerciseModel.sectionid = [lowerResultSet stringForColumn:@"sectionid"];
            exerciseModel.twoobjectid = [lowerResultSet stringForColumn:@"twoobjectid"];
            exerciseModel.stid = [lowerResultSet stringForColumn:@"stid"];
            exerciseModel.stname = [lowerResultSet stringForColumn:@"stname"];
            exerciseModel.subjectid = [lowerResultSet stringForColumn:@"subjectid"];
            exerciseModel.userlowertk = 0;
            exerciseModel.correct = arc4random_uniform(12) + 60;
            exerciseModel.num = (((NSInteger)[[NSDate date] timeIntervalSince1970]) % 5000) / 3 + exerciseModel.lowertknumb / 2;
            exerciseModel.meanTime = arc4random_uniform(30) + 30;
            
            FMDatabase *recordDataBase = [FMDatabase databaseWithPath:[HTUserManager userManagerSqlitePath]];
            if ([recordDataBase open]) {
                FMResultSet *exerciseResultSet = [recordDataBase executeQuery:[NSString stringWithFormat:@"select * from %@ where stid = ? and userid = ? and exerciseState = 1", kuserExerciseRecordTableName], exerciseModel.stid, [HTUserManager currentUser].userid];
				while (exerciseResultSet.next) {
					exerciseModel.userlowertk = [NSString stringWithFormat:@"%ld", MIN(exerciseModel.userlowertk.integerValue + 1, exerciseModel.lowertknumb)];
				}
                [recordDataBase close];
            }
        }
        [questionDataBase close];
    }
    return exerciseModel;
}

+ (void)packQuestionModelWithExerciseModel:(HTExerciseModel *)exerciseModel startPackBlock:(void(^)(void))startPackBlock completePackBlock:(void(^)(HTQuestionModel *questionModel))completePackBlock {
	NSMutableArray *questionIdArray = [[exerciseModel.questionsid componentsSeparatedByString:@","] mutableCopy];
	FMDatabase *recordDataBase = [FMDatabase databaseWithPath:[HTUserManager userManagerSqlitePath]];
	if ([recordDataBase open]) {
		FMResultSet *exerciseResultSet;
		switch (exerciseModel.modelStyle) {
			case HTExerciseModelStyleSort: {
				exerciseResultSet = [recordDataBase executeQuery:[NSString stringWithFormat:@"select * from %@ where xuhaotikuId = ? and userid = ? and exerciseState = 1", kuserExerciseRecordTableName], exerciseModel.xuhaotikuId, [HTUserManager currentUser].userid];
				break;
			}
			default: {
				exerciseResultSet = [recordDataBase executeQuery:[NSString stringWithFormat:@"select * from %@ where stid = ? and userid = ? and exerciseState = 1", kuserExerciseRecordTableName], exerciseModel.stid, [HTUserManager currentUser].userid];
				break;
			}
		}
		while (exerciseResultSet.next) {
			NSString *questionIdString = [exerciseResultSet stringForColumn:@"questionId"];
			if (questionIdString && [questionIdArray containsObject:questionIdString]) {
				[questionIdArray removeObject:questionIdString];
			}
		}
		[recordDataBase close];
	}
	
	NSString *willPackQuestionModelId;
	switch (exerciseModel.modelStyle) {
		case HTExerciseModelStyleSort: {
			willPackQuestionModelId = questionIdArray.firstObject;
			break;
		}
		default: {
			willPackQuestionModelId = questionIdArray[arc4random() % questionIdArray.count];
			if (exerciseModel.lastRandomQuestionModel && exerciseModel.lastRandomQuestionModel.questionRead.length) {
				FMDatabase *questionDataBase = [FMDatabase databaseWithPath:[self questionManagerSqlitePath]];
				if ([questionDataBase open]) {
					NSMutableString *questionIdStringArrayString = [@"(" mutableCopy];
					[questionIdArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
						if (idx < questionIdArray.count - 1) {
							[questionIdStringArrayString appendFormat:@"%@, ", obj];
						} else {
							[questionIdStringArrayString appendFormat:@"%@)", obj];
						}
					}];
					NSString *originLastQuestionRead = [questionDataBase stringForQuery:@"select articletitle from \"x2_questions\" where questionid = ?", exerciseModel.lastRandomQuestionModel.questionId];
					FMResultSet *sameReadResultSet = [questionDataBase executeQuery:[NSString stringWithFormat:@"select * from \"x2_questions\" where articletitle = ? and questionid in %@", questionIdStringArrayString], originLastQuestionRead];
					if (sameReadResultSet.next) {
						willPackQuestionModelId = [sameReadResultSet stringForColumn:@"questionid"];
					}
					[questionDataBase close];
				}
			}
			break;
		}
	}
	void(^lastCompletePackBlock)(HTQuestionModel *) = ^(HTQuestionModel *questionModel) {
		exerciseModel.lastRandomQuestionModel = questionModel;
		if (completePackBlock) {
			completePackBlock(questionModel);
		}
	};
	[self packQuestionModelWithQuestionId:willPackQuestionModelId startPackBlock:startPackBlock completePackBlock:lastCompletePackBlock];
}

+ (void)packQuestionModelWithQuestionId:(NSString *)questionId startPackBlock:(void(^)(void))startPackBlock completePackBlock:(void(^)(HTQuestionModel *questionModel))completePackBlock {
    if (startPackBlock) {
        startPackBlock();
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
		HTQuestionModel *questionModel = [self packQuestionModelWithQuestionId:questionId];
		if (completePackBlock) {
			dispatch_async(dispatch_get_main_queue(), ^{
				completePackBlock(questionModel);
			});
		}
    });
}

+ (HTQuestionModel *)packQuestionModelWithQuestionId:(NSString *)questionId {
	HTQuestionModel *questionModel;
	FMDatabase *questionDataBase = [FMDatabase databaseWithPath:[self questionManagerSqlitePath]];
	if ([questionDataBase open]) {
		FMResultSet *questionResultSet = [questionDataBase executeQuery:@"select * from \"x2_questions\" where questionid = ?", questionId];
		if (questionResultSet.next) {
			NSString *questionTitle = [questionResultSet stringForColumn:@"question"];
			NSString *plainQuestionTitle = [questionResultSet stringForColumn:@"questiontitle"];
			NSString *questionArticle = [questionResultSet stringForColumn:@"questionarticle"];
			
			NSString *questionSelectedString = [questionResultSet stringForColumn:@"questionselect"];
			NSInteger questionSelectCount = [[questionResultSet stringForColumn:@"questionselectnumber"] integerValue];
			
			NSArray <NSString *> *questionSelectedArray = [questionSelectedString ht_componentsQuestionSelectedArrayWithQuestionSelectedCount:questionSelectCount];
			
			NSArray *parseModelArray = [self packParseModelArrayWithQuestionId:questionId];
			
			questionModel = [[HTQuestionModel alloc] initWithQuestionId:questionId questionRead:questionArticle questionTitle:questionTitle storeQuestion:false questionSelectedArray:questionSelectedArray currentQuestionNumber:0 allQuestionCount:0 parseModelArray:parseModelArray];
			questionModel.plainQuestionTitle = plainQuestionTitle;
			questionModel.storeQuestion = [self isStoredWithQuestionId:questionId];
			questionModel.trueAnswer = [questionResultSet stringForColumn:@"questionanswer"];
		}
		[questionDataBase close];
	}
	return questionModel;
}

+ (void)insertQuestionRecordWithRecordDataBase:(FMDatabase *)recordDataBase
									questionId:(NSString *)questionId
								  userIdString:(NSString *)userIdString
							questionSubmitTime:(NSString *)questionSubmitTime
										  stid:(NSString *)stid
								   xuhaotikuId:(NSString *)xuhaotikuId
							  questionDuration:(NSString *)questionDuration
							questionUserAnswer:(NSString *)questionUserAnswer
								 isRightAnswer:(NSString *)isRightAnswer
						  isHadSublimeToServer:(BOOL)isHadSublimeToServer
							   sectionIdString:(NSString *)sectionIdString
							 twoObjectIdString:(NSString *)twoObjectIdString {
	
	NSString *tableName = kuserExerciseRecordTableName;
	FMDatabase *dataBase = recordDataBase;
	NSDictionary *dictionary = @{
									 @"userid":HTPlaceholderString(userIdString, @"0"),
									 @"questionSubmitTime":HTPlaceholderString(questionSubmitTime, @""),
									 @"stid":HTPlaceholderString(stid, @"0"),
									 @"xuhaotikuId":HTPlaceholderString(xuhaotikuId, @"0"),
									 @"questionId":HTPlaceholderString(questionId, @"0"),
									 @"sectionId":HTPlaceholderString(sectionIdString, @"0"),
									 @"twoId":HTPlaceholderString(twoObjectIdString, @"0"),
									 @"questionUserAnswer":HTPlaceholderString(questionUserAnswer, @"A"),
									 @"duration":HTPlaceholderString(questionDuration, @"1"),
									 @"questionIsRight":HTPlaceholderString(isRightAnswer, @"0"),
									 @"isHadSublimeToServer":isHadSublimeToServer ? @"1" : @"0",
									 @"exerciseState":@"1",
								 };
	[self updateSqliteTableName:tableName dataBase:dataBase dictionary:dictionary primaryKey:@""];
}

+ (void)insertQuestionRecordWithQuestionId:(NSString *)questionId exerciseModel:(HTExerciseModel *)exerciseModel questionDuration:(NSString *)questionDuration questionUserAnswer:(NSString *)questionUserAnswer startPackBlock:(void(^)(void))startPackBlock completePackBlock:(void(^)(BOOL success))completePackBlock {
    FMDatabase *recordDataBase = [FMDatabase databaseWithPath:[HTUserManager userManagerSqlitePath]];
	FMDatabase *questionDataBase = [FMDatabase databaseWithPath:[self questionManagerSqlitePath]];
	
	NSString *willInsertStid;
	NSString *willInsertXuhaoTikuId;
	switch (exerciseModel.modelStyle) {
		case HTExerciseModelStyleSort: {
            willInsertStid = @"0";
            willInsertXuhaoTikuId = exerciseModel.xuhaotikuId;
			break;
		}
		default: {
            willInsertStid = exerciseModel.stid;
            willInsertXuhaoTikuId = @"0";
			break;
		}
	}
	
    if ([recordDataBase open]) {
        [self packQuestionModelWithQuestionId:questionId startPackBlock:startPackBlock completePackBlock:^(HTQuestionModel *questionModel) {
            NSString *userid = [HTUserManager currentUser].userid;
            NSString *sublimeTime = [NSString stringWithFormat:@"%ld", (NSInteger)[[NSDate date] timeIntervalSince1970]];
            NSString *isRightAnswer = [questionModel.trueAnswer isEqualToString:questionUserAnswer] ? @"1" : @"0";
            HTRecordModel *recordModel = [[HTRecordModel alloc] init];
            recordModel.userid = userid;
            recordModel.questionSubmitTime = sublimeTime;
            recordModel.questionIsRight = isRightAnswer;
            recordModel.questionId = questionId;
			recordModel.stid = willInsertStid;
			recordModel.xuhaotikuId = willInsertXuhaoTikuId;
            recordModel.duration = questionDuration;
            recordModel.questionUserAnswer = questionUserAnswer;
			if ([questionDataBase open]) {
				NSString *sectionId = [questionDataBase stringForQuery:@"select sectiontype from \"x2_questions\" where questionid = ?", questionId];
				NSString *twoId = [questionDataBase stringForQuery:@"select twoobjecttype from \"x2_questions\" where questionid = ?", questionId];
				
				switch (exerciseModel.modelStyle) {
					case HTExerciseModelStyleSort: {
						[recordDataBase executeUpdate:[NSString stringWithFormat:@"delete from %@ where userid = ? and xuhaotikuId = ? and questionId = ?", kuserExerciseRecordTableName], userid, willInsertXuhaoTikuId, questionId];
						break;
					}
					default: {
						[recordDataBase executeUpdate:[NSString stringWithFormat:@"delete from %@ where userid = ? and stid = ? and questionId = ?", kuserExerciseRecordTableName], userid, willInsertStid, questionId];
						break;
					}
				}
				
				[self insertQuestionRecordWithRecordDataBase:recordDataBase questionId:questionId userIdString:userid questionSubmitTime:sublimeTime stid:willInsertStid xuhaotikuId:willInsertXuhaoTikuId questionDuration:questionDuration questionUserAnswer:questionUserAnswer isRightAnswer:isRightAnswer isHadSublimeToServer:false sectionIdString:sectionId twoObjectIdString:twoId];
				
				[questionDataBase close];
			}
            if (completePackBlock) {
                completePackBlock(true);
            }
            [recordDataBase close];
        }];
    }
}

+ (BOOL)isStoredWithQuestionId:(NSString *)questionId {
	FMDatabase *storeDataBase = [FMDatabase databaseWithPath:[HTUserManager userManagerSqlitePath]];
	BOOL isStored = false;
    if ([storeDataBase open]) {
		@try {
			FMResultSet *storeResult = [storeDataBase executeQuery:[NSString stringWithFormat:@"select * from %@ where userid = ? and questionId = ? and storeState in ('0', '1')", kuserExerciseStoryTableName], [HTUserManager currentUser].userid, questionId];
			isStored = storeResult.next;
		} @catch (NSException *exception) {
			
		} @finally {
			[storeDataBase close];
		}
	}
	return isStored;
}

+ (void)switchStoreStateWithQuestionId:(NSString *)questionId {
	FMDatabase *storeDataBase = [FMDatabase databaseWithPath:[HTUserManager userManagerSqlitePath]];
	NSString *userid = [HTUserManager currentUser].userid;
	if ([storeDataBase open]) {
		FMResultSet *storeHistoryResult = [storeDataBase executeQuery:[NSString stringWithFormat:@"select * from %@ where userid = ? and questionId = ?", kuserExerciseStoryTableName], [HTUserManager currentUser].userid, questionId];
		if (storeHistoryResult.next) {
			NSString *storeStateString = [storeHistoryResult stringForColumn:@"storeState"];
			NSInteger storeStateInteger = storeStateString.integerValue;
			switch (storeStateInteger) {
				case 1: {
					[storeDataBase executeUpdate:[NSString stringWithFormat:@"update %@ set storeState = 2 where userid = ? and questionId = ?", kuserExerciseStoryTableName], userid, questionId];
					break;
				}
				case 2: {
					[storeDataBase executeUpdate:[NSString stringWithFormat:@"update %@ set storeState = 1 where userid = ? and questionId = ?", kuserExerciseStoryTableName], userid, questionId];
					break;
				}
				case 0: {
				}
				default: {
					[storeDataBase executeUpdate:[NSString stringWithFormat:@"delete from %@ where userid = %@ and questionId = %@", kuserExerciseStoryTableName, userid, questionId]];
					break;
				}
			}
		} else {
			FMDatabase *questionDataBase = [FMDatabase databaseWithPath:[self questionManagerSqlitePath]];
			if ([questionDataBase open]) {
				FMResultSet *questionResultSet = [questionDataBase executeQuery:@"select * from \"x2_questions\" where questionid = ?", questionId];
				if (questionResultSet.next) {
					NSString *sectionId = [questionResultSet stringForColumn:@"sectiontype"];
					NSString *twoId = [questionResultSet stringForColumn:@"twoobjecttype"];
					
					NSString *tableName = kuserExerciseStoryTableName;
					FMDatabase *dataBase = storeDataBase;
					NSString *storeTime = [NSString stringWithFormat:@"%ld", (NSInteger)[[NSDate date] timeIntervalSince1970]];
					NSDictionary *dictionary = @{
													@"storeState":@"0",
													@"userid":HTPlaceholderString(userid, @""),
													@"questionId":HTPlaceholderString(questionId, @""),
													@"storeTime":HTPlaceholderString(storeTime, @""),
													@"sectionId":HTPlaceholderString(sectionId, @""),
													@"twoId":HTPlaceholderString(twoId, @""),
												 };
					[self updateSqliteTableName:tableName dataBase:dataBase dictionary:dictionary primaryKey:@"userid, questionId"];
					
					[questionDataBase close];
				}
			}
		}
		[storeDataBase close];
	}
}


+ (void)packScoreModelWithExerciseModel:(HTExerciseModel *)exerciseModel startPackBlock:(void(^)(void))startPackBlock completePackBlock:(void(^)(HTScoreModel *scoreModel))completePackBlock {
	[self packQuestionModelArrayWithExerciseModel:exerciseModel startPackBlock:startPackBlock completePackBlock:^(NSArray<HTQuestionModel *> *questionModelArray) {
		HTScoreModel *scoreModel = [[HTScoreModel alloc] init];
		[questionModelArray enumerateObjectsUsingBlock:^(HTQuestionModel *questionModel, NSUInteger idx, BOOL * _Nonnull stop) {
			scoreModel.totletime = [NSString stringWithFormat:@"%ld", scoreModel.totletime.integerValue + questionModel.questionDuration];
			if ([questionModel.userAnswer isEqualToString:questionModel.trueAnswer]) {
				scoreModel.Qtruenum = [NSString stringWithFormat:@"%ld", scoreModel.Qtruenum.integerValue + 1];
			}
		}];
		NSString *durationString;
		if (scoreModel.totletime.integerValue > 60 * 60) {
			durationString = [NSString stringWithFormat:@"%ldh%ldm", scoreModel.totletime.integerValue / 3600, scoreModel.totletime.integerValue / 60];
		} else if (scoreModel.totletime.integerValue > 60) {
			durationString = [NSString stringWithFormat:@"%ldm%lds", scoreModel.totletime.integerValue / 60, scoreModel.totletime.integerValue % 60];
		} else {
			durationString = [NSString stringWithFormat:@"%@s", scoreModel.totletime];
		}
		scoreModel.totletime = durationString;
		scoreModel.qyesnum = [NSString stringWithFormat:@"%ld", questionModelArray.count];
		scoreModel.correct = scoreModel.Qtruenum.floatValue / scoreModel.qyesnum.floatValue * 100;
		if (completePackBlock) {
			completePackBlock(scoreModel);
		}
	}];
}


+ (void)packQuestionModelArrayWithExerciseModel:(HTExerciseModel *)exerciseModel startPackBlock:(void(^)(void))startPackBlock completePackBlock:(void(^)(NSArray <HTQuestionModel *> *questionModelArray))completePackBlock {
    if (startPackBlock) {
        startPackBlock();
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        FMDatabase *recordDataBase = [FMDatabase databaseWithPath:[HTUserManager userManagerSqlitePath]];
        if ([recordDataBase open]) {
			NSMutableArray *recordModelArray = [@[] mutableCopy];
			FMResultSet *exerciseResultSet;
			switch (exerciseModel.modelStyle) {
				case HTExerciseModelStyleSort: {
					exerciseResultSet = [recordDataBase executeQuery:[NSString stringWithFormat:@"select * from %@ where xuhaotikuId = ? and userid = ? and exerciseState = 1 order by questionSubmitTime desc limit %@ offset 0", kuserExerciseRecordTableName, [NSString stringWithFormat:@"%ld", exerciseModel.lowertknumb]], exerciseModel.xuhaotikuId, [HTUserManager currentUser].userid];
					break;
				}
				default: {
					exerciseResultSet = [recordDataBase executeQuery:[NSString stringWithFormat:@"select * from %@ where stid = ? and userid = ? and exerciseState = 1 order by questionSubmitTime desc limit %@ offset 0", kuserExerciseRecordTableName, [NSString stringWithFormat:@"%ld", exerciseModel.lowertknumb]], exerciseModel.stid, [HTUserManager currentUser].userid];
					break;
				}
			}
			while (exerciseResultSet.next) {
				NSString *questionIdString = [exerciseResultSet stringForColumn:@"questionId"];
				NSString *questionUserAnswer = [exerciseResultSet stringForColumn:@"questionUserAnswer"];
				NSString *questionDuration = [exerciseResultSet stringForColumn:@"duration"];
				HTRecordModel *recordModel = [[HTRecordModel alloc] init];
				recordModel.questionId = questionIdString;
				recordModel.questionUserAnswer = questionUserAnswer;
				recordModel.duration = questionDuration;
				[recordModelArray addObject:recordModel];
			}
			NSArray *reverseModelArray = [[recordModelArray reverseObjectEnumerator] allObjects];
			recordModelArray = [reverseModelArray mutableCopy];
            NSMutableDictionary *questionDictionary = [@{} mutableCopy];
            [recordModelArray enumerateObjectsUsingBlock:^(HTRecordModel *recordModel, NSUInteger idx, BOOL * _Nonnull stop) {
                [self packQuestionModelWithQuestionId:recordModel.questionId startPackBlock:^{
                    
                } completePackBlock:^(HTQuestionModel *questionModel) {
					questionModel.questionDuration = recordModel.duration.integerValue;
                    questionModel.userAnswer = recordModel.questionUserAnswer;
                    [questionDictionary setObject:questionModel forKey:[NSString stringWithFormat:@"%ld", idx]];
                    if (questionDictionary.count == recordModelArray.count) {
                        NSMutableArray *questionModelArray = [@[] mutableCopy];
                        NSArray *allkey = questionDictionary.allKeys;
                        NSArray *sortAllKey = [allkey sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                            return [obj1 compare:obj2 options:NSNumericSearch];
                        }];
                        [sortAllKey enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            [questionModelArray addObject:[questionDictionary valueForKey:obj]];
                        }];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completePackBlock(questionModelArray);
                        });
                    }
                }];
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completePackBlock(nil);
            });
        }
    });
}

+ (void)cleanQuestionModelArrayWithExerciseModel:(HTExerciseModel *)exerciseModel {
    FMDatabase *recordDataBase = [FMDatabase databaseWithPath:[HTUserManager userManagerSqlitePath]];
    if ([recordDataBase open]) {
		switch (exerciseModel.modelStyle) {
			case HTExerciseModelStyleSort: {
				[recordDataBase executeUpdate:[NSString stringWithFormat:@"update %@ set exerciseState = ?, isHadSublimeToServer = 0 where xuhaotikuId = ? and userid = ?", kuserExerciseRecordTableName], @"2", exerciseModel.xuhaotikuId, [HTUserManager currentUser].userid];
			}
			default: {
				[recordDataBase executeUpdate:[NSString stringWithFormat:@"update %@ set exerciseState = ?, isHadSublimeToServer = 0 where stid = ? and userid = ?", kuserExerciseRecordTableName], @"2", exerciseModel.stid, [HTUserManager currentUser].userid];
			}
		}
        [recordDataBase close];
    }
    exerciseModel.userlowertk = @"0";
}




+ (NSString *)sectionTitleWithSectionId:(NSInteger)sectionId {
	FMDatabase *questionDataBase = [FMDatabase databaseWithPath:[self questionManagerSqlitePath]];
	NSString *sectionTitle = @"未知";
	if ([questionDataBase open]) {
		sectionTitle = [questionDataBase stringForQuery:@"select section from \"x2_sections\" where sectionid = ?", [NSString stringWithFormat:@"%ld", sectionId]];
	}
	[questionDataBase close];
	return sectionTitle;
}

+ (NSString *)twoobjectTitlteWithTwoobjectId:(NSInteger)twoobjectId {
	FMDatabase *questionDataBase = [FMDatabase databaseWithPath:[self questionManagerSqlitePath]];
	NSString *twoobjectTitle = @"未知";
	if ([questionDataBase open]) {
		twoobjectTitle = [questionDataBase stringForQuery:@"select twoobjecttype from \"x2_twoobject\" where twoobjectid = ?", [NSString stringWithFormat:@"%ld", twoobjectId]];
	}
	[questionDataBase close];
	return twoobjectTitle;
}


+ (NSString *)findUserNearStid {
    NSString *nearStid = @"";
    FMDatabase *recordDataBase = [FMDatabase databaseWithPath:[HTUserManager userManagerSqlitePath]];
    if ([recordDataBase open]) {
        FMResultSet *exerciseResultSet = [recordDataBase executeQuery:[NSString stringWithFormat:@"select * from %@ where userid = ? and exerciseState = 1 order by questionSubmitTime desc limit 0, 1", kuserExerciseRecordTableName], [HTUserManager currentUser].userid];
        if (exerciseResultSet.next) {
            nearStid = [exerciseResultSet stringForColumn:@"stid"];
        }
        [recordDataBase close];
    }
    return nearStid;
}

+ (NSString *)detailStringWithStid:(NSString *)stid {
    NSString *deatilStringForStid = @"";
    FMDatabase *questionDataBase = [FMDatabase databaseWithPath:[self questionManagerSqlitePath]];
    if (questionDataBase.open) {
        FMResultSet *questionGroupSet = [questionDataBase executeQuery:@"select * from \"x2_lower_tiku\" where stid = ?", stid];
        if (questionGroupSet.next) {
            NSString *twoObjectTypeString = [questionGroupSet stringForColumn:@"twoobjectid"];
            twoObjectTypeString = [questionDataBase stringForQuery:@"select twoobjecttype from \"x2_twoobject\" where twoobjectid = ?", twoObjectTypeString];
            NSString *sectionTypeString = [questionGroupSet stringForColumn:@"sectionid"];
            sectionTypeString = [questionDataBase stringForQuery:@"select section from \"x2_sections\" where sectionid = ?", sectionTypeString];
            NSString *stnameString = [questionGroupSet stringForColumn:@"stname"];
            deatilStringForStid = [NSString stringWithFormat:@"%@-%@-%@", twoObjectTypeString.length ? twoObjectTypeString : @"", sectionTypeString.length ? sectionTypeString : @"", stnameString.length ? stnameString : @""];
        }
        [questionDataBase close];
    }
    return deatilStringForStid;
}

+ (NSString *)sumUserAllExerciseRecordCount {
    FMDatabase *recordDataBase = [FMDatabase databaseWithPath:[HTUserManager userManagerSqlitePath]];
    NSInteger sumUserAllExerciseCount = 0;
    if ([recordDataBase open]) {
        FMResultSet *userRecordSet = [recordDataBase executeQuery:[NSString stringWithFormat:@"select * from %@ where userid = ? and exerciseState = 1", kuserExerciseRecordTableName], [HTUserManager currentUser].userid];
        while (userRecordSet.next) {
            sumUserAllExerciseCount ++;
        }
        [recordDataBase close];
    }
    return [NSString stringWithFormat:@"%ld", sumUserAllExerciseCount];
}

+ (NSString *)userAllExerciseCorrect {
    FMDatabase *recordDataBase = [FMDatabase databaseWithPath:[HTUserManager userManagerSqlitePath]];
    NSInteger rightUserExerciseCount = 0;
    if ([recordDataBase open]) {
        FMResultSet *userRecordSet = [recordDataBase executeQuery:[NSString stringWithFormat:@"select * from %@ where userid = ? and questionIsRight = ? and exerciseState = 1", kuserExerciseRecordTableName], [HTUserManager currentUser].userid, @"1"];
        while (userRecordSet.next) {
            rightUserExerciseCount ++;
        }

        [recordDataBase close];
    }
    NSInteger allUserExerciseCount = [self sumUserAllExerciseRecordCount].integerValue;
    if (allUserExerciseCount == 0) {
        return @"0";
    } else {
        return [NSString stringWithFormat:@"%.lf", (rightUserExerciseCount / (CGFloat)allUserExerciseCount) * 100];
    }
}

+ (NSMutableArray <HTStoreModel *> *)packStoreItemWithSectionId:(NSString *)sectionId twoObjectIdArray:(NSArray <NSString *> *)twoObjectIdArray currentPage:(NSString *)currentPage pageCount:(NSString *)pageCount {
    FMDatabase *recordDataBase = [FMDatabase databaseWithPath:[HTUserManager userManagerSqlitePath]];
	FMDatabase *questionDataBase = [FMDatabase databaseWithPath:[self questionManagerSqlitePath]];
	NSMutableArray <HTStoreModel *> *storeModelArray = [@[] mutableCopy];
    if ([recordDataBase open]) {
		NSMutableString *twoobjectArrayString = [@"(" mutableCopy];
		[twoObjectIdArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			if (idx < twoObjectIdArray.count - 1) {
				[twoobjectArrayString appendFormat:@"%@, ", obj];
			} else {
				[twoobjectArrayString appendFormat:@"%@)", obj];
			}
		}];
        FMResultSet *storeResultSet = [recordDataBase executeQuery:[NSString stringWithFormat:@"select * from %@ where userid = %@ and storeState in ('0', '1') and sectionId = %@ and twoId in %@ order by rowid desc limit %@ offset %@", kuserExerciseStoryTableName, [HTUserManager currentUser].userid, sectionId, [NSString stringWithFormat:@"%@", twoobjectArrayString], pageCount, [NSString stringWithFormat:@"%ld", (currentPage.integerValue - 1) * pageCount.integerValue]]];
        while (storeResultSet.next) {
			NSString *questionId = [storeResultSet stringForColumn:@"questionId"];
			HTStoreModel *storeModel = [[HTStoreModel alloc] init];
			storeModel.questionid = questionId;
			if ([questionDataBase open]) {
				storeModel.section = [questionDataBase stringForQuery:@"select section from \"x2_sections\" where sectionid = ?", sectionId];
				FMResultSet *questionResultSet = [questionDataBase executeQuery:@"select * from \"x2_questions\" where questionid = ?", questionId];
				if (questionResultSet.next) {
					NSString *questionTitle = [questionResultSet stringForColumn:@"question"];
					questionTitle = [[questionTitle ht_attributedStringNeedDispatcher:nil].string ht_attributedStringNeedDispatcher:nil].string;
					storeModel.qtitle = questionTitle;
					[questionDataBase close];
					[storeModelArray addObject:storeModel];
				}
			}
        }
        [recordDataBase close];
    }
	return storeModelArray;
}

+ (NSMutableArray <HTRecordExerciseModel *> *)packExerciseModelWithSectionId:(NSString *)sectionId currentPage:(NSString *)currentPage pageCount:(NSString *)pageCount onlyNeedWrong:(BOOL)onlyNeedWrong {
	FMDatabase *recordDataBase = [FMDatabase databaseWithPath:[HTUserManager userManagerSqlitePath]];
	FMDatabase *questionDataBase = [FMDatabase databaseWithPath:[self questionManagerSqlitePath]];
	NSMutableArray <HTRecordExerciseModel *> *recordModelArray = [@[] mutableCopy];
	if ([recordDataBase open]) {
		FMResultSet *recordResultSet;
		if (onlyNeedWrong) {
			recordResultSet = [recordDataBase executeQuery:[NSString stringWithFormat:@"select * from %@ where userid = ? and sectionId = ? and questionIsRight = ? and exerciseState = 1 order by questionSubmitTime desc limit %@ offset %@", kuserExerciseRecordTableName, pageCount, [NSString stringWithFormat:@"%ld", (currentPage.integerValue - 1) * pageCount.integerValue]], [HTUserManager currentUser].userid, sectionId, @"0"];
		} else {
			recordResultSet = [recordDataBase executeQuery:[NSString stringWithFormat:@"select * from %@ where userid = ? and sectionId = ? and exerciseState = 1 order by questionSubmitTime desc limit %@ offset %@", kuserExerciseRecordTableName, pageCount, [NSString stringWithFormat:@"%ld", (currentPage.integerValue - 1) * pageCount.integerValue]], [HTUserManager currentUser].userid, sectionId];
		}
		while (recordResultSet.next) {
			HTRecordExerciseModel *recordExerciseModel = [[HTRecordExerciseModel alloc] init];
			recordExerciseModel.questionId = [recordResultSet stringForColumn:@"questionId"];
			recordExerciseModel.userAnswer = [recordResultSet stringForColumn:@"questionUserAnswer"];
			recordExerciseModel.submitTime = [recordResultSet stringForColumn:@"questionSubmitTime"];
			recordExerciseModel.duration = [recordResultSet stringForColumn:@"duration"];
			recordExerciseModel.num = [NSString stringWithFormat:@"%ld", (((NSInteger)[[NSDate date] timeIntervalSince1970]) % 5000) / 3 + recordExerciseModel.duration.integerValue * 20];
			if ([questionDataBase open]) {
				recordExerciseModel.section = [questionDataBase stringForQuery:@"select section from \"x2_sections\" where sectionid = ?", sectionId];
				FMResultSet *questionResultSet = [questionDataBase executeQuery:@"select * from \"x2_questions\" where questionid = ?", recordExerciseModel.questionId];
				if (questionResultSet.next) {
					recordExerciseModel.rightAnswer = [questionResultSet stringForColumn:@"questionanswer"];
					NSString *questionTitle = [questionResultSet stringForColumn:@"question"];
					questionTitle = [[questionTitle ht_attributedStringNeedDispatcher:nil].string ht_attributedStringNeedDispatcher:nil].string;
					recordExerciseModel.questionTitle = questionTitle;
				}
				[questionDataBase close];
			}
			[recordModelArray addObject:recordExerciseModel];
		}
		[recordDataBase close];
	}
	return recordModelArray;
}

+ (NSArray <HTQuestionParseModel *> *)packParseModelArrayWithQuestionId:(NSString *)questionId {
	FMDatabase *questionDataBase = [FMDatabase databaseWithPath:[self questionManagerSqlitePath]];
	NSMutableArray <HTQuestionParseModel *> *parseModelArray = [@[] mutableCopy];
	if ([questionDataBase open]) {
		FMResultSet *questionParseResult = [questionDataBase executeQuery:@"select * from \"x2_net_pars\" where p_questionid = ? and p_audit = 1 and p_content not like '%.mp3%' order by p_time desc limit 0, 3", questionId];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
		while (questionParseResult.next) {
			HTQuestionParseModel *parseModel = [[HTQuestionParseModel alloc] init];
			parseModel.parseSendOwner = [questionParseResult stringForColumn:@"userid"];
			parseModel.parseSendOwner = [NSString stringWithFormat:@"lgw*%@", parseModel.parseSendOwner];
			parseModel.parseDetailContent = [[questionParseResult stringForColumn:@"p_content"] ht_htmlDecodeString];
			parseModel.parseSendDate = [dateFormatter dateFromString:[questionParseResult stringForColumn:@"p_time"]];
			[parseModelArray addObject:parseModel];
		}
	}
	return parseModelArray;
}




//-----------------------------------------/ 同步做题记录 /-----------------------------------------//


/**
 同步做题记录, 上传本地的做题记录, exerciseState = 1 代表本地新增的服务器没有的数据, exerciseState = 2 代表本地重新做题的记录, 服务器会 insert 1, delete 2, 然后把服务器处理过后的所有的记录返回来, 客户端把本地删掉, 然后把服务器出来过后的记录添加到本地, 其他地方调用记录均调用本地的记录
 
 同步收藏记录, 上传本地的收藏记录, storyState = 0 代表本地的已经收藏, storyState = 1 代表服务器的已经收藏, storyState = 2 代表服务器的已经取消收藏, 取消收藏时如果 storyState 是 0 本地会把这一条记录删掉, 把 0 和 2 的传给服务器, 服务器把 0 和 2 的一起遍历, 删掉已经存在的(取消收藏), 新增不存在的(收藏)

 @param startHandleBlock 开始的 block
 @param completeHandleBlock 结束的 block
 */
+ (void)synchronousStartHandleBlock:(void(^)(void))startHandleBlock completeHandleBlock:(void(^)(NSString *errorString))completeHandleBlock {
	if (startHandleBlock) {
		startHandleBlock();
	}
	if ([[HTUserManager currentUser].userid isEqualToString:@"0"]) {
		if (completeHandleBlock) {
			completeHandleBlock(@"游客不能上传做题记录");
		}
		return;
	}
    
	NSString *userId = [HTUserManager currentUser].userid;
	dispatch_async(dispatch_get_global_queue(0, 0), ^{
		FMDatabase *recordDataBase = [FMDatabase databaseWithPath:[HTUserManager userManagerSqlitePath]];
		FMDatabase *questionDataBase = [FMDatabase databaseWithPath:[self questionManagerSqlitePath]];
		void(^closeSynchronousBlock)(NSString *errorString) = ^(NSString *errorString) {
			dispatch_async(dispatch_get_main_queue(), ^{
				if (completeHandleBlock) {
					[recordDataBase close];
					[questionDataBase close];
					completeHandleBlock(errorString);
				}
			});
		};
        
		if ([recordDataBase open] && [questionDataBase open]) {
			FMResultSet *recordResultSet = [recordDataBase executeQuery:[NSString stringWithFormat:@"select * from %@ where userid = ? and isHadSublimeToServer = ?", kuserExerciseRecordTableName], userId, @"0"];
			NSMutableArray *exerciseRecordArray = [@[] mutableCopy];
            
			while (recordResultSet.next) {
				HTRecordModel *recordModel = [[HTRecordModel alloc] init];
				recordModel.stid = [recordResultSet stringForColumn:@"stid"];
				recordModel.xuhaotikuId = [recordResultSet stringForColumn:@"xuhaotikuId"];
				recordModel.userid = [recordResultSet stringForColumn:@"userid"];
				recordModel.questionSubmitTime = [recordResultSet stringForColumn:@"questionSubmitTime"];
				recordModel.duration = [recordResultSet stringForColumn:@"duration"];
				recordModel.questionIsRight = [recordResultSet stringForColumn:@"questionIsRight"];
				recordModel.questionId = [recordResultSet stringForColumn:@"questionId"];
				recordModel.questionUserAnswer = [recordResultSet stringForColumn:@"questionUserAnswer"];
				NSString *exerciseState = [recordResultSet stringForColumn:@"exerciseState"];
				NSMutableArray *userDictionary = [recordModel.mj_keyValues mutableCopy];
				[userDictionary setValue:exerciseState forKey:@"exerciseState"];
				
				//
				NSString *questionIsRightKey = @"questionIsRight";
				BOOL right = [[userDictionary valueForKey:questionIsRightKey] boolValue];
				right = !right;
				[userDictionary setValue:[NSString stringWithFormat:@"%ld", (NSInteger)right] forKey:questionIsRightKey];
				//
				[exerciseRecordArray addObject:userDictionary];
			}
			
			NSMutableArray *storeModelArray = [@[] mutableCopy];
			FMResultSet *storeResultSet = [recordDataBase executeQuery:[NSString stringWithFormat:@"select * from %@ where userid = %@ and storeState in ('0', '2')", kuserExerciseStoryTableName, userId]];
			while (storeResultSet.next) {
				NSString *questionId = [storeResultSet stringForColumn:@"questionId"];
				NSString *userId = [storeResultSet stringForColumn:@"userid"];
				NSDictionary *storeDictionary = @{@"questionId":HTPlaceholderString(questionId, @""),
												  @"userid":HTPlaceholderString(userId, @"")};
				[storeModelArray addObject:storeDictionary];
			}
			
			NSDictionary *uploadDictionary = @{
												 @"record":exerciseRecordArray,
												 @"collect":storeModelArray
											 };
			
			
			NSData *uploadData = uploadDictionary.mj_JSONData;
			HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
			networkModel.autoAlertString = nil;
			networkModel.offlineCacheStyle = HTCacheStyleNone;
			networkModel.autoShowError = false;
			HTUploadModel *uploadModel = [[HTUploadModel alloc] init];
			uploadModel.uploadData = uploadData;
			uploadModel.uploadType = HTUploadFileDataTypeTxt;
			networkModel.uploadModelArray = @[uploadModel];
			[HTRequestManager requestOfflineRecordUploadWithNetworkModel:networkModel complete:^(id response, HTError *errorModel) {
				if (!errorModel.existError) {
					NSString *recordPath = GmatResourse(response[@"recordPath"]);
					HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
					networkModel.autoAlertString = nil;
					networkModel.offlineCacheStyle = HTCacheStyleNone;
					networkModel.autoShowError = false;
					[HTRequestManager requestOfflineRecordDownloadWithNetworkModel:networkModel downloadUrlString:recordPath complete:^(id response, HTError *errorModel) {
						if (!errorModel.existError) {
							dispatch_async(dispatch_get_global_queue(0, 0), ^{
								NSDictionary *downloadDictionary = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
								
								NSArray *downloadRecordArray = [downloadDictionary valueForKey:@"record"];
								NSArray *downloadStoreArray = [downloadDictionary valueForKey:@"collect"];
								NSMutableArray *recordModelArray = [@[] mutableCopy];
								[downloadRecordArray enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
									HTRecordModel *recordModel = [HTRecordModel mj_objectWithKeyValues:dictionary];
									recordModel.userid = userId;
									if (recordModel) {
										[recordModelArray addObject:recordModel];
									}
								}];
								
								[recordDataBase beginTransaction];
								@try {
									
									[recordDataBase executeUpdate:[NSString stringWithFormat:@"delete from %@ where userid = ?", kuserExerciseRecordTableName], userId];
									[recordDataBase executeUpdate:[NSString stringWithFormat:@"delete from %@ where userid = ?", kuserExerciseStoryTableName], userId];
									
									[recordModelArray enumerateObjectsUsingBlock:^(HTRecordModel *recordModel, NSUInteger idx, BOOL * _Nonnull stop) {
										NSString *sectionId = [questionDataBase stringForQuery:@"select sectiontype from \"x2_questions\" where questionid = ?", recordModel.questionId];
										NSString *twoId = [questionDataBase stringForQuery:@"select twoobjecttype from \"x2_questions\" where questionid = ?", recordModel.questionId];
										NSString *questionAnswer = [questionDataBase stringForQuery:@"select questionanswer from \"x2_questions\" where questionid = ?", recordModel.questionId];
										if (!recordModel.questionUserAnswer.length) {
											recordModel.questionUserAnswer = @"A";
										}
										recordModel.questionIsRight = [recordModel.questionUserAnswer isEqualToString:questionAnswer] ? @"1" : @"0";
										
										[self insertQuestionRecordWithRecordDataBase:recordDataBase questionId:recordModel.questionId userIdString:recordModel.userid questionSubmitTime:recordModel.questionSubmitTime stid:recordModel.stid xuhaotikuId:recordModel.xuhaotikuId questionDuration:recordModel.duration questionUserAnswer:recordModel.questionUserAnswer isRightAnswer:recordModel.questionIsRight isHadSublimeToServer:true sectionIdString:sectionId twoObjectIdString:twoId];
										
									}];
									
									[downloadStoreArray enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger index, BOOL * _Nonnull stop) {
										NSString *userId = HTPlaceholderString([dictionary valueForKey:@"userid"], @"");
										NSString *questionId = HTPlaceholderString([dictionary valueForKey:@"questionid"], @"");
										NSString *sectionId = [questionDataBase stringForQuery:@"select sectiontype from \"x2_questions\" where questionid = ?", questionId];
										NSString *twoId = [questionDataBase stringForQuery:@"select twoobjecttype from \"x2_questions\" where questionid = ?", questionId];
										NSString *storeTime = @"0";
										NSDictionary *insertDictionary = @{
																			 @"userid":userId,
																		 	 @"questionId":questionId,
																			 @"sectionId":sectionId,
																			 @"twoId":twoId,
																			 @"storeTime":storeTime,
																			 @"storeState":@"1",
																		 };
										[self updateSqliteTableName:kuserExerciseStoryTableName dataBase:recordDataBase dictionary:insertDictionary primaryKey:@"userid, questionId"];
									}];
									
									[recordDataBase commit];
								} @catch (NSException *exception) {
									[recordDataBase rollback];
								} @finally {
									closeSynchronousBlock(@"");
								}
							});
						} else {
							closeSynchronousBlock(@"下载失败");
						}
					}];
				} else {
					closeSynchronousBlock(@"上传失败");
				}
			}];
		} else {
			closeSynchronousBlock(@"不能打开本地数据库");
		}
	});
}









//-----------------------------------------/ 根据关键词和分页来进行题库搜索 /-----------------------------------------//



/**
 根据关键词来搜索题目, 然后打包为 model 通过 block 来返回一个 modelArray

 @param keyword 关键词
 @param pageNumber 页码
 @param pageSize 每一页多少个条目
 @param complete 完成的 block
 */
+ (void)searchWithKeyword:(NSString *)keyword pageNumber:(NSString *)pageNumber pageSize:(NSString *)pageSize complete:(void(^)(NSArray <HTQuestionModel *> *searchQuestionModelArray))complete {
	NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"[^a-zA-Z0-9\\s']" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
	keyword = [regularExpression stringByReplacingMatchesInString:keyword options:0 range:NSMakeRange(0, keyword.length) withTemplate:@" "];
	while ([keyword containsString:@"  "]) {
		keyword = [keyword stringByReplacingOccurrencesOfString:@"  " withString:@" "];
	}
    
    if (!searchOperationQueue) {
        searchOperationQueue = [[NSOperationQueue alloc] init];
        searchOperationQueue.maxConcurrentOperationCount = 1;
    }
    
    [searchOperationQueue cancelAllOperations];
    
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakOperation = operation;
    [operation addExecutionBlock:^{
        if (weakOperation.cancelled) {
            return;
        }
        FMDatabase *questionDataBase = [FMDatabase databaseWithPath:[self questionManagerSqlitePath]];
		NSArray <NSString *> *keywordArray = [keyword componentsSeparatedByString:@" "];
        if ([questionDataBase open]) {
            NSMutableDictionary <NSString *, NSNumber *> *searchHitCountDictionary = [@{} mutableCopy];
			[questionDataBase beginTransaction];
			@try {
				if (keywordArray.firstObject.length > 0) {
					NSString *firstKeyword = keywordArray.firstObject;
					FMResultSet *resultSet = [self searchResultWithDatabase:questionDataBase operation:weakOperation keyword:firstKeyword prefix:true];
					[self ht_handleDealSearchResult:resultSet operation:weakOperation searchHitCountDictionary:searchHitCountDictionary hitAppendNumber:20];
				}
				NSInteger maxSearchCount = 30;
				if (keywordArray.count > maxSearchCount) {
					keywordArray = [keywordArray sortedArrayUsingComparator:^NSComparisonResult(NSString *string1, NSString *string2) {
						NSInteger length1 = string1.length;
						NSInteger length2 = string2.length;
						if (length1 > length2) {
							return NSOrderedAscending;
						} else if (length1 == length2) {
							return NSOrderedSame;
						} else {
							return NSOrderedDescending;
						}
					}];
					keywordArray = [keywordArray subarrayWithRange:NSMakeRange(0, maxSearchCount)];
				}
				for (NSString *string in keywordArray) {
					if (weakOperation.cancelled) {
						return;
					}
					if (string.length > 1) {
						FMResultSet *resultSet = [self searchResultWithDatabase:questionDataBase operation:weakOperation keyword:string prefix:false];
						[self ht_handleDealSearchResult:resultSet operation:weakOperation searchHitCountDictionary:searchHitCountDictionary hitAppendNumber:1];
					}
				}
				NSArray *searchHitCountAllKeys = [searchHitCountDictionary keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
					return [obj2 compare:obj1];
				}];
				
				[self convertQuestionIdArray:searchHitCountAllKeys pageNumber:pageNumber pageSize:pageSize questionDataBase:questionDataBase operation:weakOperation toQuestionModelArrayBlock:^(NSArray<HTQuestionModel *> *questionModelArray) {
					if (!weakOperation.cancelled && complete) {
						[[NSOperationQueue mainQueue] addOperationWithBlock:^{
							complete(questionModelArray);
						}];
					}
				}];
				[questionDataBase commit];
			} @catch (NSException *exception) {
				[questionDataBase rollback];
			} @finally {
				[questionDataBase close];
			}
        }
    }];
    [searchOperationQueue addOperation:operation];
}



/**
 根据关键词来创建 FMResultSet

 @param dataBase 已打开的数据库
 @param operation 已创建的队列
 @param keyword 关键词
 @param prefix 如果要查找这个关键词开头的, 传 true, 反之如果是包含这个关键词的, 传 false
 @return 返回一个 FMResultSet 交给其他方法进行处理
 */
+ (FMResultSet *)searchResultWithDatabase:(FMDatabase *)dataBase operation:(NSOperation *)operation keyword:(NSString *)keyword prefix:(BOOL)prefix {
    if (operation.cancelled) {
        return nil;
    }
    FMResultSet *resultSet;
    NSString *likeKeywordString = [NSString stringWithFormat:prefix ? @"'%@%%'" : @"'%%%@%%'", keyword];
    NSString *sqlsearchString = [NSString stringWithFormat:@"select * from \"x2_questions\" where questiontitle like %@ or questionselect like %@ or articletitle like %@ or questionid like %@", likeKeywordString, likeKeywordString, likeKeywordString, likeKeywordString];
    resultSet = [dataBase executeQuery:sqlsearchString];
    return resultSet;
}


/**
 处理上面创建的 FMResultSet

 @param resultSet 传进一个创建好 FMResultSet
 @param operation 已创建的队列
 @param searchHitCountDictionary (NSString *questionId, NSNumber *) 这是一个key=questionid, value=这个questionid的命中数的字典, 命中数关系到搜索出来的questionid数据排序
 @param hitAppendNumber 如果要查找这个关键词开头的, 一般增加的命中数会高一点, 反之如果是包含这个关键词的, 增加的命中数会低一点, 比如 hitAppendNumber = 1, 直接 ++
 */
+ (void)ht_handleDealSearchResult:(FMResultSet *)resultSet operation:(NSOperation *)operation searchHitCountDictionary:(NSDictionary *)searchHitCountDictionary hitAppendNumber:(NSInteger)hitAppendNumber {
    while (resultSet.next) {
        if (operation.cancelled) {
            return;
        }
        NSString *questionId = [resultSet stringForColumn:@"questionid"];
        NSNumber *hitNumber = [searchHitCountDictionary valueForKey:questionId];
        hitNumber = @(hitNumber.integerValue + hitAppendNumber);
        [searchHitCountDictionary setValue:hitNumber forKey:questionId];
    }
}


/**
 等把 questionId 都搜索出来, 排序后传进来处理分页, 返回转化为 modelArray 返回去

 @param questionIdArray 搜索的问题的 id 的数组
 @param pageNumber 页码
 @param pageSize 每页数量
 @param questionDataBase 已打开的数据库
 @param operation 已创建的队列
 @param toQuestionModelArrayBlock 完成的时候把 modelArray 返回去
 */
+ (void)convertQuestionIdArray:(NSArray <NSString *> *)questionIdArray pageNumber:(NSString *)pageNumber pageSize:(NSString *)pageSize questionDataBase:(FMDatabase *)questionDataBase operation:(NSOperation *)operation toQuestionModelArrayBlock:(void(^)(NSArray <HTQuestionModel *> *))toQuestionModelArrayBlock {
	
	NSInteger pageIntegerNumber = pageNumber.integerValue;
	NSInteger pageIntegerSize = pageSize.integerValue;
	if (questionIdArray.count > pageIntegerNumber * pageIntegerSize) {
		questionIdArray = [questionIdArray subarrayWithRange:NSMakeRange((pageIntegerNumber - 1) * pageIntegerSize, pageIntegerSize)];
	}
	
    NSMutableArray *sortQuestionModelArray = [@[] mutableCopy];
    NSMutableArray *searchQuestionModelArray = [@[] mutableCopy];
    [questionIdArray enumerateObjectsUsingBlock:^(NSString *questionId, NSUInteger index, BOOL * _Nonnull stop) {
        if (operation.cancelled) {
            *stop = true;
        } else {
			NSString *searchQuestionString = [NSString stringWithFormat:@"select * from \"x2_questions\" where questionid like %@", questionId];
			FMResultSet *resultSet = [questionDataBase executeQuery:searchQuestionString];
			if (resultSet.next) {
				NSString *questionPlainTitle = [resultSet stringForColumn:@"questiontitle"];
				HTQuestionModel *questionModel = [[HTQuestionModel alloc] init];
				questionModel.questionId = questionId;
				questionModel.plainQuestionTitle = questionPlainTitle;
				if (!operation.cancelled) {
					[searchQuestionModelArray addObject:questionModel];
					if (index == questionIdArray.count - 1) {
						for (NSString *questionId in questionIdArray) {
							for (HTQuestionModel *questionModel in searchQuestionModelArray) {
								if ([questionModel.questionId isEqualToString:questionId]) {
									[sortQuestionModelArray addObject:questionModel];
								}
							}
						}
						if (toQuestionModelArrayBlock) {
							toQuestionModelArrayBlock(sortQuestionModelArray);
						}
					}
				}
			}
        }
    }];
    if (toQuestionModelArrayBlock) {
        toQuestionModelArrayBlock(sortQuestionModelArray);
    }
}














//-----------------------------------------/ 题库更新 /-----------------------------------------//





/**
 找到本地 sqlite 的单个表的所有字段

 @param tableName 表名
 @param dataBase 已经打开的 sqlite 数据库
 @return 返回这个字段组成的数组
 */
+ (NSArray *)findSqliteAllKeyArrayWithTableName:(NSString *)tableName dataBase:(FMDatabase *)dataBase {
	NSMutableArray *allKeyArray = [@[] mutableCopy];
	NSString *sqliteString = [NSString stringWithFormat:@"pragma table_info([%@])", tableName];
	FMResultSet *resultSet = [dataBase executeQuery:sqliteString];
	while (resultSet.next) {
		NSString *keyName = [resultSet stringForColumn:@"name"];
		[allKeyArray addObject:keyName];
	}
	return allKeyArray;
}


/**
 根据一个本地表的所有字段的数组来剔除要插入或者更新的字典里面多余的键值对

 @param dictionary 要插入或者更新的字典
 @param allKeyArray 一个本地表的所有字段的数组
 @return 返回新的字典
 */
+ (NSDictionary *)deleteDictionaryKeyValue:(NSDictionary *)dictionary withAllKeyArray:(NSArray *)allKeyArray {
	NSMutableDictionary *changeDictionary = [@{} mutableCopy];
	[allKeyArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger index, BOOL * _Nonnull stop) {
		id value = [dictionary valueForKey:key];
		if (value) {
			[changeDictionary setValue:value forKey:key];
		}
	}];
	return changeDictionary;
}


/**
 根据一个字典来更新或者插入本地数据库的一条数据, 根据主键进行查询, 然后判断是插入还是更新

 @param tableName 表名
 @param dataBase 已经打开的 sqlite 数据库
 @param dictionary 要更新或者插入的数据
 @param primaryKey 这一堆的数据的主键是什么, 这个表的主键是什么, 如果没有那么不执行更新, 只执行插入, 如果有多个, 用逗号隔开
 @return 返回更新或者插入是否成功
 */
+ (BOOL)updateSqliteTableName:(NSString *)tableName dataBase:(FMDatabase *)dataBase dictionary:(NSDictionary *)dictionary primaryKey:(NSString *)primaryKey {
	
	BOOL success = false;
	
	BOOL exist = false;
	
	NSArray *primaryKeyArray = [primaryKey componentsSeparatedByString:@","];
	__block NSString *selectedPrimaryString = @"";
	[primaryKeyArray enumerateObjectsUsingBlock:^(NSString *primaryKey, NSUInteger index, BOOL * _Nonnull stop) {
		NSString *primaryKeyString = [primaryKey stringByReplacingOccurrencesOfString:@" " withString:@""];
		id primaryValueContent = [dictionary valueForKey:primaryKeyString];
		primaryValueContent = primaryValueContent ? primaryValueContent : @"";
		selectedPrimaryString = [NSString stringWithFormat:@"%@%@%@ = %@", selectedPrimaryString, index > 0 ? @" and " : @"", primaryKeyString, primaryValueContent];
	}];
	NSString *existPrimaryString = [NSString stringWithFormat:@"select * from %@ where %@", tableName, selectedPrimaryString];
	if (primaryKey.length) {
		if ([dataBase executeQuery:existPrimaryString].next) {
			exist = true;
		}
	} else {
		exist = false;
	}
	
	if (exist) {
		NSMutableArray *updateSetArray = [@[] mutableCopy];
		[dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id  _Nonnull value, BOOL * _Nonnull stop) {
			NSString *sqlitePointValue = [value stringByReplacingOccurrencesOfString:@"\'" withString:@"''"];
			NSString *setString = [NSString stringWithFormat:@"%@ = '%@'", key, sqlitePointValue];
			[updateSetArray addObject:setString];
		}];
		NSString *updateSetString = [updateSetArray componentsJoinedByString:@", "];
		NSString *updateSqliteString = [NSString stringWithFormat:@"update %@ set %@ where %@", tableName, updateSetString, selectedPrimaryString];
		success = [dataBase executeUpdate:updateSqliteString];
	} else {
		NSArray *allkeyArray = dictionary.allKeys;
		NSString *allkeyString = [allkeyArray componentsJoinedByString:@", "];
		
		NSArray *allValueArray = [dictionary objectsForKeys:allkeyArray notFoundMarker:@""];
		NSMutableArray *pointAllValueArray = [@[] mutableCopy];
		[allValueArray enumerateObjectsUsingBlock:^(NSString *value, NSUInteger idx, BOOL * _Nonnull stop) {
			NSString *sqlitePointValue = [value stringByReplacingOccurrencesOfString:@"\'" withString:@"''"];
			[pointAllValueArray addObject:[NSString stringWithFormat:@"'%@'", sqlitePointValue]];
		}];
		NSString *allValueString = [pointAllValueArray componentsJoinedByString:@", "];
		
		NSString *insertSqliteString = [NSString stringWithFormat:@"insert into %@ (%@) values (%@)", tableName, allkeyString, allValueString];
		success = [dataBase executeUpdate:insertSqliteString];
	}
	
	
	return success;
}


/**
 本地题库更新, 包含判断是否需要更新, 如果需要更新下载要更新的json文件, 调用上方的方法查询表内所有的key, 然后循环调用上方的单个插入或者更新的方法

 @param startHandleBlock 开始
 @param progressHandleBlock 进度条
 @param completeHandleBlock 完成
 */
+ (void)downloadUpdateSqliteStartHandleBlock:(void (^)(void))startHandleBlock progressHandleBlock:(HTUserTaskProgressBlock)progressHandleBlock completeHandleBlock:(void (^)(NSString *))completeHandleBlock {
	if (startHandleBlock) {
		startHandleBlock();
	}
	HTNetworkModel *urlNetworkModel = [[HTNetworkModel alloc] init];
	urlNetworkModel.autoShowError = false;
	urlNetworkModel.autoAlertString = nil;
	urlNetworkModel.offlineCacheStyle = HTCacheStyleNone;
	NSString *localSqliteLastUpdateTime = [self localSqliteLastUpdateTime];
	[HTRequestManager requestSqliteUpdateWithNetworkModel:urlNetworkModel localSqliteLastUpdateTime:localSqliteLastUpdateTime complete:^(id response, HTError *errorModel) {
		if (!errorModel.existError || errorModel.errorType == HTErrorTypeUnknown) {
			if ([response[@"code"] integerValue] == 1) {
				NSString *downloadFileUrl = response[@"url"];
				NSString *responseUpdateTime = response[@"time"];
				HTNetworkModel *downloadNetworkModel = [[HTNetworkModel alloc] init];
				downloadNetworkModel.autoShowError = false;
				downloadNetworkModel.autoAlertString = nil;
				downloadNetworkModel.offlineCacheStyle = HTCacheStyleNone;
				[downloadNetworkModel setTaskProgressBlock:progressHandleBlock];
				[HTRequestManager requestSqliteUpdateFileDownloadWithNetworkModel:downloadNetworkModel downloadSqliteUrl:downloadFileUrl complete:^(NSData *response, HTError *errorModel) {
					if (!errorModel.existError) {
						FMDatabase *questionDataBase = [FMDatabase databaseWithPath:[self questionManagerSqlitePath]];
						if ([questionDataBase open]) {
							
							[questionDataBase beginTransaction];
							@try {
								NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
								HTSqliteUpdateModel *sqliteModel = [HTSqliteUpdateModel mj_objectWithKeyValues:responseDictionary];
								NSArray *(^notNullArrayBlock)(NSArray *) = ^(NSArray *inputArray) {
									return inputArray ? inputArray : @[];
								};
								NSString *willUpdateTableNameKey = @"willUpdateTableNameKey";
								NSString *willUpdatePrimaryKey = @"willUpdatePrimaryKey";
								NSString *willUpdateModelArray = @"willUpdateModelArray";
								NSArray *willUpdateKeyValueArray = @[
																		@{willUpdateTableNameKey:@"x2_net_pars", willUpdatePrimaryKey:@"parsid", willUpdateModelArray:notNullArrayBlock(sqliteModel.parse)},
																		@{willUpdateTableNameKey:@"x2_questions", willUpdatePrimaryKey:@"questionid", willUpdateModelArray:notNullArrayBlock(sqliteModel.question)},
																		@{willUpdateTableNameKey:@"x2_lower_tiku", willUpdatePrimaryKey:@"stid", willUpdateModelArray:notNullArrayBlock(sqliteModel.tiku)},
																		@{willUpdateTableNameKey:@"x2_xuhao_question", willUpdatePrimaryKey:@"id", willUpdateModelArray:notNullArrayBlock(sqliteModel.xuhaoquestion)},
																		@{willUpdateTableNameKey:@"x2_xuhao_tiku", willUpdatePrimaryKey:@"id", willUpdateModelArray:notNullArrayBlock(sqliteModel.xuhao)},
																	];
								[willUpdateKeyValueArray enumerateObjectsUsingBlock:^(NSDictionary *tableInfoDictionary, NSUInteger index, BOOL * _Nonnull stop) {
									NSString *tableName = tableInfoDictionary[willUpdateTableNameKey];
									NSString *tablePrimaryKey = tableInfoDictionary[willUpdatePrimaryKey];
									NSArray *updateModelArray = tableInfoDictionary[willUpdateModelArray];
									NSArray *tableAllKeyArray = [self findSqliteAllKeyArrayWithTableName:tableName dataBase:questionDataBase];
									[updateModelArray enumerateObjectsUsingBlock:^(id  model, NSUInteger index, BOOL * _Nonnull stop) {
										NSDictionary *modelKeyValueDictionary = [model mj_keyValues];
										modelKeyValueDictionary = [self deleteDictionaryKeyValue:modelKeyValueDictionary withAllKeyArray:tableAllKeyArray];
										[self updateSqliteTableName:tableName dataBase:questionDataBase dictionary:modelKeyValueDictionary primaryKey:tablePrimaryKey];
									}];
								}];
								
								[questionDataBase commit];
								[self setLocalSqliteLastUpdateTime:responseUpdateTime];
								completeHandleBlock(nil);
							} @catch (NSException *exception) {
								[questionDataBase rollback];
								completeHandleBlock(@"操作数据库出错啦");
							} @finally {
								[questionDataBase close];
							}
						} else {
							completeHandleBlock(@"不能打开本地数据库");
						}
					} else {
						completeHandleBlock(@"下载文件失败");
					}
				}];
			} else {
				completeHandleBlock(@"已经是最新最新的了");
			}
		} else {
			completeHandleBlock(@"连接服务器失败");
		}
	}];
}



/**
 下面两个方法是题库更新的版本控制 setter getter
 
 */

+ (NSString *)localSqliteLastUpdateTime {
	NSString *localSqliteLastUpdateTime = [[NSUserDefaults standardUserDefaults] valueForKey:kHTLocalSqliteLastUpdateTimeKey];
	localSqliteLastUpdateTime = HTPlaceholderString(localSqliteLastUpdateTime, @"1505383077");
	return localSqliteLastUpdateTime;
}

+ (void)setLocalSqliteLastUpdateTime:(NSString *)localSqliteLastUpdateTime {
	[[NSUserDefaults standardUserDefaults] setValue:localSqliteLastUpdateTime forKey:kHTLocalSqliteLastUpdateTimeKey];
}




@end
