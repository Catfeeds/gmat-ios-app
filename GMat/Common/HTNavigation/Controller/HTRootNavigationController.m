//
//  HTRootNavigationController.m
//  GMat
//
//  Created by hublot on 2017/4/21.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTRootNavigationController.h"
#import "HTManagerController+HTRotate.h"
#import <objc/runtime.h>

@interface HTRootNavigationController ()

@end

@implementation HTRootNavigationController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	self.transferNavigationBarAttributes = true;
	self.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]};
	self.navigationBar.barTintColor = [UIColor ht_colorStyle:HTColorStyleSecondaryTheme];
	self.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.hidesBottomBarWhenPushed = self.childViewControllers.count;
	[super pushViewController:viewController animated:animated];

	if (viewController.rt_navigationController) {
		viewController.navigationController.view = viewController.navigationController.view;
	}
}

@end
