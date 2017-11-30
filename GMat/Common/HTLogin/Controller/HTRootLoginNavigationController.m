//
//  HTRootLoginNavigationController.m
//  GMat
//
//  Created by hublot on 2017/4/21.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTRootLoginNavigationController.h"

@interface HTRootLoginNavigationController ()

@end

@implementation HTRootLoginNavigationController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	if (self.dismissLoginControllerComplete) {
		self.dismissLoginControllerComplete();
	}
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	self.transferNavigationBarAttributes = true;
	UIImage *image = [[UIImage alloc] init];
	[self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
	[self.navigationBar setShadowImage:image];
	self.navigationBar.translucent = true;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
	[super pushViewController:viewController animated:animated];
	if (viewController.childViewControllers.count) {
		viewController.childViewControllers.lastObject.childViewControllers.lastObject.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"MineLogin2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonTaped)];
	} else {
		viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"MineLogin2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonTaped)];
	}
}

- (void)backButtonTaped {
	if (self.childViewControllers.count == 1) {
		[self dismissViewControllerAnimated:true completion:nil];
	} else {
		[self removeViewController:self.rt_topViewController animated:true];
	}
}

@end
