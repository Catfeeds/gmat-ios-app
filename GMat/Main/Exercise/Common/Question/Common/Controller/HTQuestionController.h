//
//  HTQuestionController.h
//  GMat
//
//  Created by hublot on 2016/11/9.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTScoreController.h"
#import "HTQuestionViewGroup.h"
#import "HTSingleQuestionModel.h"
#import "HTGroupQuestionModel.h"
#import "HTQuestionControllerBlocks.h"

@interface HTQuestionController : UIViewController

@property (nonatomic, strong) HTQuestionControllerBlocks *blockPackage;

@property (nonatomic, strong) HTQuestionViewGroup *questionViewGroup;

@end
