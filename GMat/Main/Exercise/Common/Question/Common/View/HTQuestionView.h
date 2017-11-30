//
//  HTQuestionView.h
//  GMat
//
//  Created by hublot on 2016/11/9.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTQuestionModel.h"

@interface HTQuestionView : UIView

@property (nonatomic, strong) NSString *userSelectedAnswer;

@property (nonatomic, assign) BOOL showUserExerciseDuration;

@property (nonatomic, assign) BOOL showUserAnswerParse;


@property (nonatomic, strong) UILabel *bottomRightAnswerLabel;

- (void)setModel:(HTQuestionModel *)model tableView:(UITableView *)tableView;

- (void)computeQuestionViewHeight;

@end
