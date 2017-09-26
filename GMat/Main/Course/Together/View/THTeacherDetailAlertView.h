//
//  THTeacherDetailAlertView.h
//  TingApp
//
//  Created by hublot on 16/8/31.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THTeacherDetailAlertView : UIView

+ (void)showTeacherAlert:(void(^)(NSString *firstTextFieldString, NSString *secondTextFieldString))teacherAlert;

@end
