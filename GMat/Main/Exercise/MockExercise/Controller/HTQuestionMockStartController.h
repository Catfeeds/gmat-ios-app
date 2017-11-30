//
//  HTQuestionMockStartController.h
//  GMat
//
//  Created by hublot on 2016/11/29.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTQuestionMockStartController : UIViewController

@property (nonatomic, assign) NSInteger mockStartType;

@property (nonatomic, copy) void(^popControllerBlock)(void);

@end
