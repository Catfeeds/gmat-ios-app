//
//  THMinePreferenceInputController.h
//  TingApp
//
//  Created by hublot on 16/9/1.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, THMinePreferenceInputStyle) {
	THMinePreferenceInputName,
	THMinePreferenceInputPhone,
	THMinePreferenceInputEmail,
	THMinePreferenceInputPassword
};

@interface THMinePreferenceInputController : UIViewController

@property (nonatomic, assign) THMinePreferenceInputStyle inputStyle;

@end
