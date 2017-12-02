//
//  THExerciseExamListenAnswerNavigationButton.h
//  TingApp
//
//  Created by hublot on 16/9/13.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTQuestionModel.h"

@interface THExerciseExamListenAnswerNavigationButton : UIButton

@property (nonatomic, strong) UILabel *titleNameLabel;

- (void)setModel:(HTQuestionModel *)model;

@end
