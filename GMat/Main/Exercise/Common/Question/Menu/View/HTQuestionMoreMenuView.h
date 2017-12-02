//
//  HTQuestionMoreMenuView.h
//  GMat
//
//  Created by hublot on 2017/8/23.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTQuestionMoreMenuModel.h"

typedef void(^HTQuestionMoreItemDidSelected)(HTQuestionMoreMenuModel *model);

@interface HTQuestionMoreMenuView : UIView

+ (void)showModelArray:(NSArray <HTQuestionMoreMenuModel *> *)modelArray screenEdge:(UIEdgeInsets)screenEdge didSelectedBlock:(HTQuestionMoreItemDidSelected)didSelectedBlock;

@end
