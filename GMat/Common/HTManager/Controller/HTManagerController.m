//
//  HTManagerController.m
//  GMat
//
//  Created by hublot on 16/10/11.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTManagerController.h"
#import "HTLoginManager.h"
#import "HTUpdateModel.h"
#import "HTManagerController+HTLaunch.h"
#import "HTManagerController+HTRotate.h"

@interface HTManagerController ()

@end

@implementation HTManagerController

+ (HTManagerController *)defaultManagerController {
	static HTManagerController *managerController;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		managerController = [[HTManagerController alloc] init];
	});
	return managerController;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	[self addChildViewController:self.drawerController];
	[self.view addSubview:self.drawerController.view];
	[self.drawerController didMoveToParentViewController:self];
	[self launchChildController];
}


- (HTDrawerController *)drawerController {
	if (!_drawerController) {
		_drawerController = [[HTDrawerController alloc] init];
	}
	return _drawerController;
}

- (THManagerModel *)managerModel {
    if (!_managerModel) {
        _managerModel = [[THManagerModel alloc] init];
    }
    return _managerModel;
}

- (HTCommunityController *)communityController {
	if (!_communityController) {
		_communityController = [[HTCommunityController alloc] init];
	}
	return _communityController;
}

- (THToeflDiscoverController *)discoverController {
    if (!_discoverController) {
        _discoverController = [[THToeflDiscoverController alloc] init];
    }
    return _discoverController;
}

- (HTStoryController *)storyController {
    if (!_storyController) {
        _storyController = [[HTStoryController alloc] init];
    }
    return _storyController;
}


@end
