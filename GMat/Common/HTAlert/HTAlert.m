//
//  HTAlert.m
//  GMat
//
//  Created by hublot on 17/5/22.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTAlert.h"
#import "RKDropdownAlert.h"
#import "BQActivityView.h"
#import "HTManagerController.h"
#import "THWarnAlert.h"
#import "SCCatWaitingHUD.h"

@implementation HTAlert

+ (void)showProgress {
    [[SCCatWaitingHUD sharedInstance] animateWithInteractionEnabled:false title:@"Loading" duration:2];
	[SCCatWaitingHUD sharedInstance].backgroundWindow.hidden = false;
}

+ (void)hideProgress {
    [[SCCatWaitingHUD sharedInstance] animateWithInteractionEnabled:false title:@"Loading" duration:2];
    [SCCatWaitingHUD sharedInstance].backgroundWindow.hidden = true;
}





+ (void)title:(NSString *)title {
    [RKDropdownAlert title:title backgroundColor:[UIColor ht_colorStyle:HTColorStylePrimaryTheme] textColor:[UIColor ht_colorStyle:HTColorStyleBackground] time:1];
}

+ (void)title:(NSString *)title message:(NSString *)message {
    [RKDropdownAlert title:title message:message backgroundColor:[UIColor ht_colorStyle:HTColorStylePrimaryTheme] textColor:[UIColor ht_colorStyle:HTColorStyleBackground] time:1];
}





+ (void)title:(NSString *)title sureAction:(void(^)(void))sureAction {
    [self title:nil message:title sureAction:sureAction cancelAction:nil animated:true completion:nil];
}

+ (void)title:(NSString *)title message:(NSString *)message sureAction:(void(^)(void))sureAction cancelAction:(void(^)(void))cancelAction animated:(BOOL)animated completion:(void(^)(void))completion {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    __weak UIAlertController *weakAlertController = alertController;
    UIAlertAction *sureAlertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (sureAction) {
            sureAction();
        }
        [weakAlertController dismissViewControllerAnimated:true completion:nil];
    }];
    UIAlertAction *cancelAlertAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (cancelAction) {
            cancelAction();
        }
        [weakAlertController dismissViewControllerAnimated:true completion:nil];
    }];
    [alertController addAction:cancelAlertAction];
    [alertController addAction:sureAlertAction];
    [[HTManagerController defaultManagerController] presentViewController:alertController animated:animated completion:completion];
}






+ (void)title:(NSString *)title message:(NSString *)message sureAction:(void(^)(void))sureAction {
    [THWarnAlert title:title message:message sureAction:sureAction];
}





+ (HTOctopusAlertView *)title:(NSString *)title message:(NSString *)message tryAgainTitle:(NSString *)tryAgainTitle tryAgainBlock:(void(^)(void))tryAgainBlock {
    return [HTOctopusAlertView title:title message:message tryAgainTitle:tryAgainTitle tryAgainBlock:tryAgainBlock];
}

+ (void)tryAgaginDismissAlert {
    [HTOctopusAlertView dissmissAlert];
}





+ (HTCenterLabelAlert *)centerTitle:(NSString *)centerTitle {
    return [HTCenterLabelAlert title:centerTitle];
}

+ (HTCircleLabelAlert *)circleTitle:(NSString *)circleTitle superView:(UIView *)superView {
    return [HTCircleLabelAlert title:circleTitle superView:superView];
}

@end
