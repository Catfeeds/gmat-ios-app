//
//  HTManagerController.h
//  GMat
//
//  Created by hublot on 16/10/11.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTDrawerController.h"
#import "THManagerModel.h"
#import "HTCommunityController.h"
#import "THToeflDiscoverController.h"
#import "HTStoryController.h"

@interface HTManagerController : UIViewController

+ (HTManagerController *)defaultManagerController;

@property (nonatomic, strong) HTDrawerController *drawerController;

@property (nonatomic, strong) THManagerModel *managerModel;

@property (nonatomic, strong) HTCommunityController *communityController;

@property (nonatomic, strong) THToeflDiscoverController *discoverController;

@property (nonatomic, strong) HTStoryController *storyController;

@end
