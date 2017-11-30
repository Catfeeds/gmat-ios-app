//
//  HTPlayerNavigationBar.h
//  GMat
//
//  Created by hublot on 2017/9/26.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTPlayerModel.h"

@interface HTPlayerNavigationBar : UIView

@property (nonatomic, strong) HTPlayerModel *playerModel;

@property (nonatomic, strong) UIButton *speedButton;

@property (nonatomic, strong) UIButton *teacherButton;

@end
