//
//  HTExerciseCountView.h
//  GMat
//
//  Created by hublot on 2017/5/17.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTExerciseQuestionCountModel.h"

@interface HTExerciseCountView : UIView

- (void)setModel:(HTExerciseQuestionCountModel *)model row:(NSInteger)row;

@property (nonatomic, assign) CGFloat blurProgress;

@end
