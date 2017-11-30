//
//  HTQuestionViewGroup.h
//  GMat
//
//  Created by hublot on 16/11/27.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTQuestionView.h"
#import "HTQuestionMoreMenuModel.h"
#import "HTQuestionMoreMenuView.h"

@interface HTQuestionViewGroup : NSObject

@property (nonatomic, assign) BOOL isHiddenAnalysis; //是否隐藏 @"解析 item"

@property (nonatomic, strong) UIToolbar *statusEffectBar;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HTQuestionView *questionView;

@property (nonatomic, strong) UIButton *bottomSureButton;

//解析
@property (nonatomic, strong) UIButton *analysisButton;

//讨论
@property (nonatomic, strong) UIButton *discussButton;

@property (nonatomic, strong) UIButton *storeBarButton;

@property (nonatomic, strong) UIButton *timeBarButton;

@property (nonatomic, strong) UIBarButtonItem *closeBarButtonItem;

@property (nonatomic, strong) UIBarButtonItem *storeBarButtonItem;

@property (nonatomic, strong) UIBarButtonItem *moreBarButtonItem;

@property (nonatomic, strong) UIBarButtonItem *timeBarButtonItem;

@property (nonatomic, assign) BOOL enable;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger lastTime;

@property (nonatomic, assign) BOOL questionParseHidden;

@property (nonatomic, assign) BOOL questionParseSelected;

@property (nonatomic, copy) HTQuestionMoreItemDidSelected moreItemDidSelected;

@end
