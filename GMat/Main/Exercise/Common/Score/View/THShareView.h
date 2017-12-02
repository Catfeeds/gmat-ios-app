//
//  THShareView.h
//  TingApp
//
//  Created by hublot on 16/9/4.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>

@interface THShareView : UIView

+ (void)showTitle:(NSString *)title detail:(NSString *)detail image:(id)image url:(NSString *)url type:(SSDKContentType)type;

@end
