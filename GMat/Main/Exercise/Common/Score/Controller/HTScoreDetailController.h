//
//  HTScoreDetailController.h
//  GMat
//
//  Created by hublot on 16/11/27.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTQuestionModel.h"
#import "HTQuestionView.h"

@interface HTScoreDetailController : UIViewController

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HTQuestionView *headerQuestionView;

@end
