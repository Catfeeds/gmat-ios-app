//
//  HTScoreController.h
//  GMat
//
//  Created by hublot on 2016/11/11.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTScoreModel.h"
#import "HTQuestionModel.h"

@class HTQuestionControllerBlocks;

@interface HTScoreController : UIViewController

@property (nonatomic, copy) void(^requestScoreModelBlock)(void(^)(HTScoreModel *scoreModel, HTError *errorModel));

@property (nonatomic, copy) void(^requestDetailModelBlock)(HTScoreModel *scoreModel, void(^)(NSArray <HTQuestionModel *> *questionModelArray));

@property (nonatomic, copy) void(^clearQuestoinGroupBlock)(void(^clearQuestionGroupComplete)(NSString *errorString));

@property (nonatomic, strong) HTQuestionControllerBlocks *blockPacket;

@end
