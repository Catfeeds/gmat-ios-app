//
//  HTDrawerController.m
//  GMat
//
//  Created by hublot on 16/10/12.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTDrawerController.h"
#import "HTRootNavigationController.h"

#define DraWerMaxWidth HTSCREENWIDTH * 0.7

#define DrawerCenterWidth HTSCREENWIDTH * 0.4

#define DrawerGestureBeginWidth 40





@interface HTDrawerController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *tapCloseView;

@end

@implementation HTDrawerController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	[self addChildViewController:self.leftController];
	[self.view addSubview:self.leftController.view];
	[self.leftController didMoveToParentViewController:self];
	
	[self addChildViewController:self.tabBarController];
	[self.view addSubview:self.tabBarController.view];
	[self.tabBarController didMoveToParentViewController:self];
	[self.view addGestureRecognizer:self.panGesture];
}

- (void)switchDrawerState {
	BOOL closeDrawer = false;
	CGFloat duration = 0;
	if (self.tabBarController.view.ht_x == 0) {
		closeDrawer = false;
		duration = 0.001 * DraWerMaxWidth;
		[self.tabBarController.view addSubview:self.tapCloseView];
	} else if (self.tabBarController.view.ht_x < DrawerCenterWidth) {
		closeDrawer = true;
        duration = 0.002 * MIN(self.tabBarController.view.ht_x, DraWerMaxWidth - self.tabBarController.view.ht_x);
    } else if (self.tabBarController.view.ht_x < DraWerMaxWidth) {
        closeDrawer = false;
        duration = 0.002 * MIN(self.tabBarController.view.ht_x, DraWerMaxWidth - self.tabBarController.view.ht_x);
    } else if (self.tabBarController.view.ht_x == DraWerMaxWidth) {
		closeDrawer = true;
		duration = 0.001 * DraWerMaxWidth;
	}
	self.tabBarController.hamburgerButton.showMenu = !closeDrawer;
	[UIView animateWithDuration:duration animations:^{
		self.tabBarController.view.ht_x = closeDrawer ? 0 : DraWerMaxWidth;
		self.leftController.view.ht_x = closeDrawer ? - DraWerMaxWidth / 2 : 0;
	} completion:^(BOOL finished) {
		if (closeDrawer) {
			[self.tapCloseView removeFromSuperview];
		}
	}];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    UINavigationController *navigationController = self.tabBarController.selectedViewController;
    if (navigationController.viewControllers.count > 1) {
        return false;
    }
    
	CGFloat location = [gestureRecognizer locationInView:self.view].x;
	if ((self.tabBarController.view.ht_x == 0 && location >= DrawerGestureBeginWidth) || (self.tabBarController.view.ht_x == DraWerMaxWidth && location < DraWerMaxWidth)) {
		return false;
	}

	return true;
}

- (HTLeftController *)leftController {
	if (!_leftController) {
		_leftController = [[HTLeftController alloc] init];
		_leftController.view.ht_x = - DraWerMaxWidth / 2;
	}
	return _leftController;
}

- (HTTabBarController *)tabBarController {
	if (!_tabBarController) {
		_tabBarController = [[HTTabBarController alloc] init];
	}
	return _tabBarController;
}

- (UIPanGestureRecognizer *)panGesture {
	if (!_panGesture) {
		_panGesture = [[UIPanGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
			UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)sender;
			CGFloat translation = [panGesture translationInView:sender.view].x;
			if (state == UIGestureRecognizerStateBegan) {
				[panGesture setTranslation:CGPointMake(self.tabBarController.view.ht_x, 0) inView:panGesture.view];
				[self.tabBarController.view addSubview:self.tapCloseView];
			} else if (state == UIGestureRecognizerStateChanged) {
				if (translation <= DraWerMaxWidth && translation >= 0) {
					self.tabBarController.hamburgerButton.progress = translation * 2 / DraWerMaxWidth;
					self.tabBarController.view.ht_x = translation;
					self.leftController.view.ht_x = (translation - DraWerMaxWidth) / 2;
				}
			} else if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled) {
				[self switchDrawerState];
			}
		}];
		_panGesture.delegate = self;
	}
	return _panGesture;
}

- (UIView *)tapCloseView {
	if (!_tapCloseView) {
		_tapCloseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HTSCREENWIDTH, self.view.ht_h)];
		[_tapCloseView ht_whenTap:^(UIView *view) {
			[self switchDrawerState];
			self.tabBarController.hamburgerButton.showMenu = false;
		}];
	}
	return _tapCloseView;
}


@end
