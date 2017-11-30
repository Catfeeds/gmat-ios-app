//
//  HTExerciseHeaderView.h
//  GMat
//
//  Created by hublot on 2017/5/17.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTExerciseCountView.h"
#include "HTExerciseSearchView.h"

@interface HTExerciseHeaderView : UIView

@property (nonatomic, strong) HTExerciseCountView *exerciseCountView;

@property (nonatomic, strong) HTExerciseSearchView *exerciseSearchView;

@end
