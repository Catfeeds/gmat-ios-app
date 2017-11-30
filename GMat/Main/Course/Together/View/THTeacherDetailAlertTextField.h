//
//  THTeacherDetailAlertTextField.h
//  TingApp
//
//  Created by hublot on 16/8/31.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THTeacherDetailAlertTextField : UIView

@property (nonatomic, strong) NSString *text;

- (instancetype)initWithFrame:(CGRect)frame helpLabelText:(NSString *)helpLabelText;

- (void)hideKeyBoard;

@end
