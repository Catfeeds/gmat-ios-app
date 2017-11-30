//
//  HTManagerController+HTPresent.h
//  GMat
//
//  Created by hublot on 2017/7/14.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTManagerController.h"

@interface UIViewController (HTPresentController)

@property (nonatomic, assign) BOOL ht_presentAnimation;

@property (nonatomic, copy) void(^ht_presentComplete)(void);

@property (nonatomic, copy) void(^ht_dismissComplete)(void);

@end

@interface HTManagerController (HTPresent)

@end
