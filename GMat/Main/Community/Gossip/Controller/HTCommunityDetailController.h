//
//  HTCommunityDetailController.h
//  GMat
//
//  Created by hublot on 2016/10/26.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HTKeyboardController.h>
#import "HTCommunityCell.h"

@interface HTCommunityDetailController : HTKeyboardController

@property (nonatomic, strong) void(^detailDidDismissBlock)(HTCommunityModel *communityModel);

@property (nonatomic, copy) NSString *communityIdString;

@end
