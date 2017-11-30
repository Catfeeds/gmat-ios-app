//
//  HTSearchQuestionController.h
//  GMat
//
//  Created by hublot on 2017/3/24.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTSearchQuestionController : UIViewController

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) void(^tryAgainCutImageBlock)(void);

@end
