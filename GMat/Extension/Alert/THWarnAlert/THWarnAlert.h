//
//  THWarnAlert.h
//  TingApp
//
//  Created by hublot on 16/8/26.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THWarnAlert : UIView

+ (void)title:(NSString *)title message:(NSString *)message sureAction:(void(^)(void))sureAction;

@end
