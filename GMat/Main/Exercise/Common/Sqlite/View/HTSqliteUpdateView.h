//
//  HTSqliteUpdateView.h
//  GMat
//
//  Created by hublot on 2017/8/22.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTSqliteUpdateView : UIView

+ (void)showUpdateAlertViewInSuperView:(UIView *)superView sureButtonBlock:(void(^)(HTSqliteUpdateView *))sureButtonBlock;

+ (void)removeUpdateAlerView;

@end
