//
//  HTDrawerController.h
//  GMat
//
//  Created by hublot on 16/10/12.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTabBarController.h"
#import "HTLeftController.h"

@interface HTDrawerController : UIViewController

@property (nonatomic, strong) HTLeftController *leftController;

@property (nonatomic, strong) HTTabBarController *tabBarController;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

- (void)switchDrawerState;

@end
