//
//  HTQuestionControllerBlocks.h
//  GMat
//
//  Created by hublot on 2017/2/28.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTQuestionModel.h"
#import "HTExerciseModel.h"
#import "HTQuestionMockStartController.h"
#import "HTQuestionMockSleepController.h"
#import "HTScoreController.h"

typedef void(^HTPermissionFailBlockName)(void);

typedef void(^HTResponseErrorBlockName)(HTError *errorModel);

typedef void(^HTQuestionResponseBlockName)(HTQuestionModel *questionModel, id originResponse);

typedef void(^HTRequestQuestionModelBlockName)(HTQuestionResponseBlockName, HTPermissionFailBlockName);

typedef void(^HTQuestionStoreButtonDidTapedBlockName)(HTQuestionModel *questionModel);

typedef void(^HTQuestionSubmitBlockName)(HTQuestionModel *questionModel, NSString *questionDuration, NSString *questionUseranswer, void(^)(NSString *errorString));

typedef void(^HTQuestionInitializeMockBlockName)(HTResponseErrorBlockName, HTPermissionFailBlockName);

typedef NSString *(^HTQuestionNavigationItemTitleName)(HTQuestionModel *questonModel);

typedef NSArray <UIBarButtonItem *> *(^HTQuestionNavigationItemArray)(UIBarButtonItem *timeBarButtonItem, UIBarButtonItem *storeBarButtonItem, UIBarButtonItem *moreBarButtonItem);





@interface HTQuestionControllerBlocks : NSObject

@property (nonatomic, copy) HTRequestQuestionModelBlockName requestQuestionModelBlock;

@property (nonatomic, copy) HTQuestionStoreButtonDidTapedBlockName questionStoreButtonDidTapedBlock;

@property (nonatomic, copy) HTQuestionSubmitBlockName questionSubmitBlock;

@property (nonatomic, copy) HTQuestionInitializeMockBlockName questionInitializeMockBlock;

@property (nonatomic, copy) HTQuestionNavigationItemTitleName questionNavigationItemTitle;

@property (nonatomic, copy) HTQuestionNavigationItemArray questionNavigationItemArray;

@property (nonatomic, assign) BOOL showParseEnable;

@property (nonatomic, assign) BOOL defaultDisplayParse;

@property (nonatomic, strong) NSString *continueIconType;

@property (nonatomic, strong) HTQuestionMockStartController *mockStartController;

@property (nonatomic, strong) HTQuestionMockSleepController *mockSleepController;

- (instancetype)initWithNavigationControllerToPushQuestionController:(UINavigationController *)navigationController exerciseModel:(HTExerciseModel *)exerciseModel;

//- (instancetype)initWithAutoExercise;

- (instancetype)initWithQuestionId:(NSString *)questionId;

- (instancetype)initWithSearchQuestionId:(NSString *)questionId;

- (instancetype)initWithNavigationControllerToPushMockQuestionController:(UINavigationController *)navigationController exerciseModel:(HTExerciseModel *)exerciseModel;

+ (HTScoreController *)scoreControllerWithExerciseModel:(HTExerciseModel *)exerciseModel;

+ (HTScoreController *)scoreControllerWithMockExerciseModel:(HTExerciseModel *)exerciseModel;



@end
