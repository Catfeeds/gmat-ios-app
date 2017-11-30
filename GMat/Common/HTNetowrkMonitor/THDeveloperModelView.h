//
//  THDeveloperModelView.h
//  TingApp
//
//  Created by hublot on 2017/1/5.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THDeveloperModelView : UIView

+ (BOOL)isDeveloperModel;

+ (void)updateDeveloperModelView;

+ (void)receiveNetworkResponse:(id)networkResponse;

@end

@interface HTFPSLabel : UILabel

@end
