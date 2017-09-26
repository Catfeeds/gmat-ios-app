//
//  THToeflDiscoverDetailController.h
//  TingApp
//
//  Created by hublot on 16/9/4.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HTKeyboardController.h>
#import "THToeflDiscoverModel.h"

@interface THToeflDiscoverDetailController : HTKeyboardController

@property (nonatomic, strong) void(^detailDidDismissBlock)(THToeflDiscoverModel *discoverModel);

@property (nonatomic, strong) NSString *discoverId;

@end
