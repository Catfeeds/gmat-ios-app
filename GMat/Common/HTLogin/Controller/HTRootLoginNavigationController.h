//
//  HTRootLoginNavigationController.h
//  GMat
//
//  Created by hublot on 2017/4/21.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "RTRootNavigationController.h"

@interface HTRootLoginNavigationController : RTRootNavigationController

@property (nonatomic, copy) void(^dismissLoginControllerComplete)(void);

@end
