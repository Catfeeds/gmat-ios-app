//
//  HTScoreDetailContentController.h
//  GMat
//
//  Created by hublot on 16/11/27.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "VTMagicController.h"
#import "HTQuestionModel.h"

@interface HTScoreDetailContentController : VTMagicController

@property (nonatomic, strong) NSArray <HTQuestionModel *> *questionModelArray;

@end
