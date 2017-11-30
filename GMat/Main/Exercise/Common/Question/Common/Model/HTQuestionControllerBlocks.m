//
//  HTQuestionControllerBlocks.m
//  GMat
//
//  Created by hublot on 2017/2/28.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTQuestionControllerBlocks.h"
#import "HTQuestionManager.h"
#import "HTQuestionController.h"
#import "HTLoginManager.h"
#import "NSString+HTString.h"
#import "HTUserActionManager.h"

@interface HTQuestionControllerBlocks ()

@end

@implementation HTQuestionControllerBlocks

- (void)dealloc {
    
}

- (instancetype)initWithNavigationControllerToPushQuestionController:(UINavigationController *)navigationController exerciseModel:(HTExerciseModel *)exerciseModel {
	if (self = [super init]) {
		[self setRequestQuestionModelBlock:^void(void (^updateQuestionUserInterface)(HTQuestionModel *, id originResponse), void(^permissionFailBlock)(void)) {
			if ([HTUserManager currentUser].permission < HTUserPermissionExerciseAbleVisitor) {
				if (permissionFailBlock) {
					permissionFailBlock();
				}
			}
			[HTUserManager surePermissionHighOrEqual:HTUserPermissionExerciseAbleVisitor passCompareBlock:^(HTUser *user) {
				[HTQuestionManager packQuestionModelWithExerciseModel:exerciseModel startPackBlock:^{
					[HTAlert showProgress];
				} completePackBlock:^(HTQuestionModel *questionModel) {
					[HTAlert hideProgress];
					updateQuestionUserInterface(questionModel, nil);
				}];
			}];
		}];
		[self setQuestionStoreButtonDidTapedBlock:^(HTQuestionModel *questionModel) {
			[HTQuestionManager switchStoreStateWithQuestionId:questionModel.questionId];
		}];
		[self setQuestionSubmitBlock:^(HTQuestionModel *questionModel, NSString *questionDuration, NSString *questionUserAnswer, void (^updateUserInterfaceBlock)(NSString *)) {
			[HTQuestionManager insertQuestionRecordWithQuestionId:questionModel.questionId exerciseModel:exerciseModel questionDuration:questionDuration questionUserAnswer:questionUserAnswer startPackBlock:^{
				[HTAlert showProgress];
			} completePackBlock:^(BOOL success) {
				[HTUserActionManager trackUserActionWithType:HTUserActionTypeCompleteSingleQuestion keyValue:@{@"questionid":questionModel.questionId}];
				
				[HTAlert hideProgress];
				exerciseModel.userlowertk = [NSString stringWithFormat:@"%ld", exerciseModel.userlowertk.integerValue + 1];
				if (exerciseModel.userlowertk.integerValue >= exerciseModel.lowertknumb) {
					exerciseModel.userlowertk = [NSString stringWithFormat:@"%ld", exerciseModel.lowertknumb];
                    HTScoreController *scoreController = [HTQuestionControllerBlocks scoreControllerWithExerciseModel:exerciseModel];
                    HTQuestionControllerBlocks *blocksPackage = [[HTQuestionControllerBlocks alloc] initWithNavigationControllerToPushQuestionController:navigationController exerciseModel:exerciseModel];
                    scoreController.blockPacket = blocksPackage;
                    [navigationController popViewControllerAnimated:false];
					[[NSUserDefaults standardUserDefaults]setObject:nil forKey:HTPlaceholderString([HTUserManager currentUser].uid,@"0")];
                    [navigationController pushViewController:scoreController animated:true];
				} else {
					updateUserInterfaceBlock(@"");
				}
			}];
		}];
		[self setQuestionNavigationItemArray:^NSArray<UIBarButtonItem *> *(UIBarButtonItem *timeBarButtonItem, UIBarButtonItem *storeBarButtonItem, UIBarButtonItem *moreBarButtonItem) {
			return @[timeBarButtonItem, storeBarButtonItem, moreBarButtonItem];
		}];
		self.showParseEnable = true;
		[self setQuestionNavigationItemTitle:^NSString *(HTQuestionModel *questionModel) {
			return [NSString stringWithFormat:@"%ld / %ld", exerciseModel.userlowertk.integerValue + 1, exerciseModel.lowertknumb];
		}];
	}
	return self;
}

- (instancetype)initWithQuestionId:(NSString *)questionId {
    if (self = [super init]) {
        [self setRequestQuestionModelBlock:^void(void (^requestQuestionStatus)(HTQuestionModel *, id), void(^permissionFailBlock)(void)) {
			[HTUserManager surePermissionHighOrEqual:HTUserPermissionExerciseAbleVisitor passCompareBlock:^(HTUser *user) {
				[HTQuestionManager packQuestionModelWithQuestionId:questionId startPackBlock:^{
					[HTAlert showProgress];
				} completePackBlock:^(HTQuestionModel *questionModel) {
					requestQuestionStatus(questionModel, nil);
					[HTAlert hideProgress];
				}];
			}];
        }];
        [self setQuestionStoreButtonDidTapedBlock:^(HTQuestionModel *questionModel) {
            [HTQuestionManager switchStoreStateWithQuestionId:questionModel.questionId];
        }];
        [self setQuestionNavigationItemTitle:^NSString *(HTQuestionModel *questionModel) {
            return @"题目详情";
        }];
		self.showParseEnable = true;
        [self setQuestionNavigationItemArray:^NSArray<UIBarButtonItem *> *(UIBarButtonItem *timeBarButtonItem, UIBarButtonItem *storeBarButtonItem, UIBarButtonItem *moreBarButtonItem) {
            return @[storeBarButtonItem, moreBarButtonItem];
        }];
    }
    return self;
}

- (instancetype)initWithSearchQuestionId:(NSString *)questionId {
	if (self = [super init]) {
		[self setRequestQuestionModelBlock:^void(void (^requestQuestionStatus)(HTQuestionModel *, id), void(^permissionFailBlock)(void)) {
			[HTUserManager surePermissionHighOrEqual:HTUserPermissionExerciseAbleVisitor passCompareBlock:^(HTUser *user) {
				[HTQuestionManager packQuestionModelWithQuestionId:questionId startPackBlock:^{
					[HTAlert showProgress];
				} completePackBlock:^(HTQuestionModel *questionModel) {
					requestQuestionStatus(questionModel, nil);
					[HTAlert hideProgress];
				}];
			}];
		}];
		[self setQuestionStoreButtonDidTapedBlock:^(HTQuestionModel *questionModel) {
			[HTQuestionManager switchStoreStateWithQuestionId:questionModel.questionId];
		}];
		[self setQuestionNavigationItemTitle:^NSString *(HTQuestionModel *questionModel) {
			return @"题目详情";
		}];
		self.showParseEnable = true;
		[self setQuestionNavigationItemArray:^NSArray<UIBarButtonItem *> *(UIBarButtonItem *timeBarButtonItem, UIBarButtonItem *storeBarButtonItem, UIBarButtonItem *moreBarButtonItem) {
			return @[storeBarButtonItem, moreBarButtonItem];
		}];
		self.defaultDisplayParse = true;
	}
	return self;
}

- (instancetype)initWithNavigationControllerToPushMockQuestionController:(UINavigationController *)navigationController exerciseModel:(HTExerciseModel *)exerciseModel {
    if (self = [super init]) {
        __weak typeof(HTQuestionControllerBlocks) *weakSelf = self;
        self.mockStartController.navigationItem.title = exerciseModel.name;
        self.mockStartController.mockStartType = exerciseModel.mockStartType;
        
        self.mockSleepController.navigationItem.title = exerciseModel.name;
		
        [self setQuestionStoreButtonDidTapedBlock:^(HTQuestionModel *questionModel) {
            [HTQuestionManager switchStoreStateWithQuestionId:questionModel.questionId];
        }];
		
		[self setQuestionInitializeMockBlock:^void(void(^questionInitializeState)(HTError *errorModel), void(^permissionFailBlock)(void)) {
			HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
			networkModel.autoAlertString = @"";
			networkModel.offlineCacheStyle = HTCacheStyleNone;
			networkModel.autoShowError = false;
			
			if ([HTUserManager currentUser].permission < HTUserPermissionExerciseAbleUser) {
				if (permissionFailBlock) {
					permissionFailBlock();
				}
			}
			
			[HTUserManager surePermissionHighOrEqual:HTUserPermissionExerciseAbleUser passCompareBlock:^(HTUser *user) {
				HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
				networkModel.autoAlertString = @"";
				networkModel.offlineCacheStyle = HTCacheStyleNone;
				networkModel.autoShowError = false;
				[HTRequestManager requestMockWillSendMockIdWithNetworkModel:networkModel mockIdString:exerciseModel.Id complete:^(id response, HTError *errorModel) {
					if (errorModel.existError) {
						questionInitializeState(errorModel);
						return;
					}
					NSInteger codeInteger = [[response valueForKey:@"code"] integerValue];
					if (codeInteger == 2) {
						[weakSelf handleMockResultControllerWithResponse:response navigationController:navigationController exerciseModel:exerciseModel];
					} else if (codeInteger == 3) {
						[weakSelf handleMockStartControllerWithResponse:response navigationController:navigationController exerciseModel:exerciseModel questionInitializeState:questionInitializeState];
					} else if (codeInteger == 6) {
						[weakSelf handleResetSignStringForExerciseModel:exerciseModel mockSignStyle:HTMockStyleVerbal];
						questionInitializeState(nil);
					} else if (codeInteger == 4) {
						[weakSelf handleResetSignStringForExerciseModel:exerciseModel mockSignStyle:HTMockStyleQuant];
						questionInitializeState(nil);
					} else if (codeInteger == 5) {
						[weakSelf handleMockSleepControllerWithResponse:response navigationController:navigationController exerciseModel:exerciseModel questionInitializeState:questionInitializeState questionResponseBlock:nil permissionFailBlock:nil];
					}
				}];
			}];
		}];
		
        [self setRequestQuestionModelBlock:^void(void (^requestQuestionState)(HTQuestionModel *, id originResponse), void(^permissionFailBlock)(void)) {
			if ([HTUserManager currentUser].permission < HTUserPermissionExerciseAbleUser) {
				if (permissionFailBlock) {
					permissionFailBlock();
				}
			}
			
            [HTUserManager surePermissionHighOrEqual:HTUserPermissionExerciseAbleUser passCompareBlock:^(HTUser *user) {
				HTNetworkModel *questionNetworkModel = [[HTNetworkModel alloc] init];
				questionNetworkModel.autoAlertString = @"获取模考题目中";
				questionNetworkModel.offlineCacheStyle = HTCacheStyleSingleUser;
				questionNetworkModel.autoShowError = true;
				[HTRequestManager requestMockQuestionWithNetworkModel:questionNetworkModel signString:exerciseModel.mockSignString complete:^(id response, HTError *errorModel) {
					NSInteger codeInteger = [[response valueForKey:@"code"] integerValue];
					if (codeInteger == 1) {
						HTGroupQuestionModel *responseModel = [HTGroupQuestionModel mj_objectWithKeyValues:response];
						NSMutableArray *questionSelectedArray = [@[] mutableCopy];
						[responseModel.data.qslctarr enumerateObjectsUsingBlock:^(HTQuestionSelectedQslctarr * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
							[questionSelectedArray addObject:obj.select];
						}];
						NSArray <HTQuestionParseModel *> *parseModelArray = [HTQuestionManager packParseModelArrayWithQuestionId:responseModel.data.questionid];
						HTQuestionModel *questionModel = [[HTQuestionModel alloc] initWithQuestionId:responseModel.data.questionid questionRead:responseModel.data.questionarticle questionTitle:responseModel.data.question storeQuestion:[HTQuestionManager isStoredWithQuestionId:responseModel.data.questionid] questionSelectedArray:questionSelectedArray currentQuestionNumber:responseModel.Do allQuestionCount:responseModel.all parseModelArray:parseModelArray];
						questionModel.trueAnswer = responseModel.data.questionanswer;
						if (requestQuestionState) {
							requestQuestionState(questionModel, response);
						}
					} else if (codeInteger == 2) {
						[HTUserActionManager trackUserActionWithType:HTUserActionTypeCompleteSingleMock keyValue:@{@"mockid":exerciseModel.Id}];
						[weakSelf handleMockResultControllerWithResponse:response navigationController:navigationController exerciseModel:exerciseModel];
					} else if (codeInteger == 5) {
						[weakSelf handleMockSleepControllerWithResponse:response navigationController:navigationController exerciseModel:exerciseModel questionInitializeState:nil questionResponseBlock:requestQuestionState permissionFailBlock:permissionFailBlock];
					}
				}];
            }];
        }];
		
        [self setQuestionSubmitBlock:^(HTQuestionModel *questionModel, NSString *questionDuration, NSString *questionUseranswer, void (^questionSubmitStatus)(NSString *)) {
			HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
			networkModel.autoAlertString = @"提交题目答案中";
			networkModel.offlineCacheStyle = HTCacheStyleNone;
			networkModel.autoShowError = true;
			[HTRequestManager requestMockSaveAnswerWithNetworkModel:networkModel questionIdString:questionModel.questionId answerString:questionUseranswer durationString:questionDuration complete:^(id response, HTError *errorModel) {
				if (errorModel.existError) {
					return;
				}
                exerciseModel.userlowertk = [NSString stringWithFormat:@"%ld", questionModel.currentQuestionNumber];
				questionSubmitStatus(@"");
			}];
        }];
        
        [self setQuestionNavigationItemTitle:^NSString *(HTQuestionModel *questionModel) {
            return [NSString stringWithFormat:@"%ld / %ld", questionModel.currentQuestionNumber, questionModel.allQuestionCount];
        }];
		
		self.showParseEnable = false;
        [self setQuestionNavigationItemArray:^NSArray<UIBarButtonItem *> *(UIBarButtonItem *timeBarButtonItem, UIBarButtonItem *storeBarButtonItem, UIBarButtonItem *moreBarButtonItem) {
            return @[timeBarButtonItem, storeBarButtonItem, moreBarButtonItem];
        }];
        
    }
    return self;
}

- (void)handleResetSignStringForExerciseModel:(HTExerciseModel *)exerciseModel mockSignStyle:(HTMockStyle)mockSignStyle {
	NSString *mockSignString = nil;
	switch (mockSignStyle) {
		case HTMockStyleVerbal:
			mockSignString = @"verbal";
			break;
		case HTMockStyleQuant:
			mockSignString = @"quant";
			break;
		case HTMockStyleQuantAndVerbal:
			break;
	}
	if (mockSignString.length) {
		[self handleResponseSignStringForExerciseModel:exerciseModel mockSignString:mockSignString];
	}
}

- (void)handleResponseSignStringForExerciseModel:(HTExerciseModel *)exerciseModel mockSignString:(NSString *)mockSignString {
	exerciseModel.mockSignString = mockSignString;
}

- (void)handleMockStartControllerWithResponse:(id)response navigationController:(UINavigationController *)navigationController exerciseModel:(HTExerciseModel *)exerciseModel questionInitializeState:(HTResponseErrorBlockName)questionInitializeState {
	
	__weak typeof(self) weakSelf = self;
	HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
	networkModel.autoAlertString = @"";
	networkModel.offlineCacheStyle = HTCacheStyleNone;
	networkModel.autoShowError = false;
	[HTRequestManager requestMockStartMessageWithNetworkModel:networkModel complete:^(id response, HTError *errorModel) {
		if (errorModel.existError) {
			questionInitializeState(errorModel);
			return;
		}
		NSString *signString = [response valueForKey:@"sign"];
		if (signString.length) {
			[weakSelf handleResponseSignStringForExerciseModel:exerciseModel mockSignString:signString];
		}
		if (weakSelf.mockStartController && signString.length) {
			[weakSelf.mockStartController setPopControllerBlock:^{
				questionInitializeState(nil);
				weakSelf.mockStartController = nil;
			}];
			exerciseModel.markquestion = @"1";
			[navigationController pushViewController:weakSelf.mockStartController animated:true];
		}
	}];
}

- (void)handleMockSleepControllerWithResponse:(id)response navigationController:(UINavigationController *)navigationController exerciseModel:(HTExerciseModel *)exerciseModel questionInitializeState:(HTResponseErrorBlockName)questionInitializeState questionResponseBlock:(HTQuestionResponseBlockName)questionResponseBlock permissionFailBlock:(HTPermissionFailBlockName)permissionFailBlock {
	
	__weak typeof(self) weakSelf = self;
	HTNetworkModel *networkModel = [HTNetworkModel modelForOnlyCacheNoInterfaceForScrollViewWithCacheStyle:HTCacheStyleNone];
	[HTRequestManager requestMockSleepBeginWithNetworkModel:networkModel complete:^(id response, HTError *errorModel) {
		HTQuestionMockSleepController *sleepController = weakSelf.mockSleepController;
		[sleepController setPopControllerBlock:^(void) {
			[HTRequestManager requestMockSleepEndWithNetworkModel:networkModel complete:^(id response, HTError *errorModel) {
				exerciseModel.mockSignString = @"verbal";
				if (questionInitializeState) {
					questionInitializeState(nil);
				} else if (questionResponseBlock && permissionFailBlock) {
					weakSelf.requestQuestionModelBlock(questionResponseBlock, permissionFailBlock);
				}
			}];
			weakSelf.mockSleepController = nil;
		}];
		[navigationController pushViewController:sleepController animated:true];
	}];
}

- (void)handleMockResultControllerWithResponse:(id)response navigationController:(UINavigationController *)navigationController exerciseModel:(HTExerciseModel *)exerciseModel {
	exerciseModel.markquestion = @"2";
	exerciseModel.userlowertk = [NSString stringWithFormat:@"%ld", exerciseModel.lowertknumb];
	exerciseModel.mkscoreid = [response valueForKey:@"mkscoreid"];
	HTScoreController *scoreController = [HTQuestionControllerBlocks scoreControllerWithMockExerciseModel:exerciseModel];
	HTQuestionControllerBlocks *blocksPackage = [[HTQuestionControllerBlocks alloc] initWithNavigationControllerToPushMockQuestionController:navigationController exerciseModel:exerciseModel];
	scoreController.blockPacket = blocksPackage;
	[[NSUserDefaults standardUserDefaults]setObject:nil forKey:HTPlaceholderString([HTUserManager currentUser].uid,@"0")];
	[navigationController popViewControllerAnimated:false];
	
	[navigationController pushViewController:scoreController animated:true];
}

- (HTQuestionMockStartController *)mockStartController {
	if (!_mockStartController) {
		_mockStartController = [[HTQuestionMockStartController alloc] init];
	}
	return _mockStartController;
}

- (HTQuestionMockSleepController *)mockSleepController {
	if (!_mockSleepController) {
		_mockSleepController = [[HTQuestionMockSleepController alloc] init];
	}
	return _mockSleepController;
}

+ (HTScoreController *)scoreControllerWithExerciseModel:(HTExerciseModel *)exerciseModel {
    HTScoreController *scoreController = [[HTScoreController alloc] init];
    scoreController = [[HTScoreController alloc] init];
    [scoreController setRequestScoreModelBlock:^(void (^requestScoreModelStatus)(HTScoreModel *, HTError *errorModel)) {
        [HTQuestionManager packScoreModelWithExerciseModel:exerciseModel startPackBlock:^{
        } completePackBlock:^(HTScoreModel *scoreModel) {
            requestScoreModelStatus(scoreModel, nil);
        }];
    }];
    [scoreController setRequestDetailModelBlock:^(HTScoreModel *scoreModel, void (^requestDetailModelStatus)(NSArray<HTQuestionModel *> *)) {
        [HTQuestionManager packQuestionModelArrayWithExerciseModel:exerciseModel startPackBlock:^{
            [HTAlert showProgress];
        } completePackBlock:^(NSArray<HTQuestionModel *> *questionModelArray) {
            [HTAlert hideProgress];
            requestDetailModelStatus(questionModelArray);
        }];
    }];
    
    [scoreController setClearQuestoinGroupBlock:^(void (^clearQuestionGroupStatus)(NSString *errorString)) {
        [HTQuestionManager cleanQuestionModelArrayWithExerciseModel:exerciseModel];
        clearQuestionGroupStatus(@"");
    }];
    return scoreController;
}

+ (HTScoreController *)scoreControllerWithMockExerciseModel:(HTExerciseModel *)exerciseModel {
    HTScoreController *scoreController = [[HTScoreController alloc] init];
    scoreController = [[HTScoreController alloc] init];
    [scoreController setRequestScoreModelBlock:^(void (^requestScoreModelStatus)(HTScoreModel *, HTError *)) {
		HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
		networkModel.autoAlertString = nil;
		networkModel.offlineCacheStyle = HTCacheStyleNone;
		networkModel.autoShowError = false;
		[HTRequestManager requestMockScoreWithNetworkModel:networkModel mockIdString:exerciseModel.Id mockScoreIdString:exerciseModel.mkscoreid complete:^(id response, HTError *errorModel) {
			if (errorModel.existError) {
				requestScoreModelStatus(nil, errorModel);
				return;
			}
			HTScoreModel *scoreModel = [HTScoreModel mj_objectWithKeyValues:response];
			scoreModel.mockStartType = exerciseModel.mockStartType;
			requestScoreModelStatus(scoreModel, nil);
		}];
    }];
    
    [scoreController setRequestDetailModelBlock:^(HTScoreModel *scoreModel, void (^requestDetailModelStatus)(NSArray<HTQuestionModel *> *)) {
        NSMutableArray *questionModelArray = [@[] mutableCopy];
        [scoreModel.questionrecord enumerateObjectsUsingBlock:^(MockScoreQuestionrecord * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableArray *qslctarrStringArray = [@[] mutableCopy];
            [obj.qslctarr enumerateObjectsUsingBlock:^(MockScoreQslctarr * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [qslctarrStringArray addObject:obj.select];
            }];
			NSArray <HTQuestionParseModel *> *parseModelArray = [HTQuestionManager packParseModelArrayWithQuestionId:obj.questionid];
			HTQuestionModel *questionModel = [[HTQuestionModel alloc] initWithQuestionId:obj.questionid questionRead:[obj.questionarticle ht_htmlDecodeString] questionTitle:obj.question storeQuestion:[HTQuestionManager isStoredWithQuestionId:obj.questionid] questionSelectedArray:qslctarrStringArray currentQuestionNumber:0 allQuestionCount:0 parseModelArray:parseModelArray];
			questionModel.questionDuration = obj.duration.integerValue;
            questionModel.userAnswer = obj.useranswer;
            questionModel.trueAnswer = obj.questionanswer;
            [questionModelArray addObject:questionModel];
        }];
        requestDetailModelStatus(questionModelArray);
    }];
    
    [scoreController setClearQuestoinGroupBlock:^(void (^clearQuestionGroupStatus)(NSString *errorString)) {
		HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
		networkModel.autoAlertString = @"重置模考进度";
		networkModel.offlineCacheStyle = HTCacheStyleNone;
		networkModel.autoShowError = true;
		[HTRequestManager requestMockReloadRecordWithNetworkModel:networkModel mockIdString:exerciseModel.Id complete:^(id response, HTError *errorModel) {
			if (errorModel.existError) {
				return;
			}
			exerciseModel.userlowertk = @"0";
			exerciseModel.markquestion = @"0";
			clearQuestionGroupStatus(@"");
		}];
    }];
    return scoreController;
}

@end
