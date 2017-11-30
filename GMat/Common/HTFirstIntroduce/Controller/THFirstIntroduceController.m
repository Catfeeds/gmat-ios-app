//
//  THFirstIntroduceController.m
//  GMat
//
//  Created by hublot on 2016/12/7.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "THFirstIntroduceController.h"
#import "HTManagerController.h"

@interface THFirstIntroduceController ()

@end

@implementation THFirstIntroduceController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:true withAnimation:UIStatusBarAnimationNone];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationNone];
    [[HTManagerController defaultManagerController].drawerController.tabBarController viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[HTManagerController defaultManagerController].drawerController.tabBarController viewDidAppear:animated];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	if (self.loadViewBlock) {
		self.loadViewBlock(self.view);
	}
	[self initializeDataSource];
	[self initializeUserInterface];
	
	
	[self removeFirstIntroduce];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
    
}

- (void)removeFirstIntroduce {
	[self viewWillDisappear:true];
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
    [self didMoveToParentViewController:nil];
	[self viewDidDisappear:true];
}

@end
