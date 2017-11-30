//
//  HTSureNicknameController.h
//  GMat
//
//  Created by hublot on 2017/7/3.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HTKeyboardController.h>

@interface HTSureNicknameController : HTKeyboardController

+ (void)presentFromController:(UIViewController *)viewController dismissNicknameBlock:(void(^)(NSString *nickname))dismissNicknameBlock;

@end
