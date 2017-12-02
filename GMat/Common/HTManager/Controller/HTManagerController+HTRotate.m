//
//  HTManagerController+HTRotate.m
//  GMat
//
//  Created by hublot on 2017/7/14.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTManagerController+HTRotate.h"
#import "RTRootNavigationController.h"
#import <NSObject+HTObjectCategory.h>

@implementation UIViewController (HTRotate)

+ (void)load {
    // 如果自己是 managerController 的 presentViewController, 系统关于旋转的属性不会再去询问 managerController,
    // 而是问 presentingViewController 要, 所以, 传回去交给 managerController 处理
    
    // 会调用下面的方法的前提是不被重写, 然后才有几种方式会被调用
    // 1. 被 present 出来的 controller 和其子 controller
    // 2. 遵守了 HTRotateScrren
    // 3. [UINavigationController popViewController] 被动调用
    
    [self ht_swizzInstanceNativeSelector:@selector(shouldAutorotate) customSelector:@selector(ht_shouldAutorotate)];
    [self ht_swizzInstanceNativeSelector:@selector(supportedInterfaceOrientations) customSelector:@selector(ht_supportedInterfaceOrientations)];
    [self ht_swizzInstanceNativeSelector:@selector(preferredInterfaceOrientationForPresentation) customSelector:@selector(ht_preferredInterfaceOrientationForPresentation)];
}

- (BOOL)ht_shouldAutorotate {
    if ([NSStringFromClass(self.class) hasPrefix:@"HT"] || [NSStringFromClass(self.class) hasPrefix:@"TH"] || [NSStringFromClass(self.class) hasPrefix:@"RT"]) {
        if (self.presentingViewController) {
            return [[HTManagerController defaultManagerController] shouldAutorotate];
        } else {
            return true;
        }
    } else {
        return [self ht_shouldAutorotate];
    }
}

- (UIInterfaceOrientationMask)ht_supportedInterfaceOrientations {
    if ([NSStringFromClass(self.class) hasPrefix:@"HT"] || [NSStringFromClass(self.class) hasPrefix:@"TH"] || [NSStringFromClass(self.class) hasPrefix:@"RT"]) {
        if (self.presentingViewController) {
            return [[HTManagerController defaultManagerController] supportedInterfaceOrientations];
        } else {
            UIViewController *conformController = [HTManagerController findRotateControllerWithHighController:self];
            if (!conformController) {
                conformController = self;
            }
            if (([conformController conformsToProtocol:@protocol(HTRotateEveryOne)]
                 || ([conformController conformsToProtocol:@protocol(HTRotateEveryOneOnlyIpad)] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad))) {
                return UIInterfaceOrientationMaskAll;
            } else {
                return UIInterfaceOrientationMaskPortrait;
            }
        }
    } else {
        return [self ht_supportedInterfaceOrientations];
    }
}

- (UIInterfaceOrientation)ht_preferredInterfaceOrientationForPresentation {
    if ([NSStringFromClass(self.class) hasPrefix:@"HT"] || [NSStringFromClass(self.class) hasPrefix:@"TH"] || [NSStringFromClass(self.class) hasPrefix:@"RT"]) {
        if (self.presentingViewController) {
            return [[HTManagerController defaultManagerController] preferredInterfaceOrientationForPresentation];
        } else {
            return UIInterfaceOrientationPortrait;
        }
    } else {
        return [self ht_preferredInterfaceOrientationForPresentation];
    }
}



// 传入一个 controller, 找到其对应的内容 controller
+ (UIViewController *)findContentControllerWithViewController:(UIViewController *)viewController {
    UIViewController *contentController = viewController;
    if ([viewController isKindOfClass:[RTContainerController class]]) {
        RTContainerController *containerController = (RTContainerController *)viewController;
        contentController = containerController.contentViewController;
    }
    return contentController;
}

// 传入一个 controller, 返回在 navigation 栈比它低的且遵守 HTRotateVisible 的 controller
+ (UIViewController *)findRotateControllerWithHighController:(UIViewController *)highController {
    UIViewController *highContentController = [self findContentControllerWithViewController:highController];
    UINavigationController *navigationController = highController.rt_navigationController;
    RTRootNavigationController *rootNavigationController = nil;
    if ([navigationController isKindOfClass:[RTRootNavigationController class]]) {
        rootNavigationController = (RTRootNavigationController *)navigationController;
    }
    NSArray *childController = navigationController.childViewControllers;
    if (rootNavigationController) {
        childController = rootNavigationController.rt_viewControllers;
    }
    UIViewController *conformRotateVisibleController = nil;
    for (UIViewController *viewController in childController) {
        if (viewController == highContentController) {
            break;
        } else if ([viewController conformsToProtocol:@protocol(HTRotateVisible)]) {
            conformRotateVisibleController = viewController;
            break;
        }
    }
    return conformRotateVisibleController;
}

@end





@implementation HTManagerController (HTRotate)

+ (void)setDeviceOrientation:(UIDeviceOrientation)orientation {
    [[UIDevice currentDevice] ht_setValue:@(orientation) forSelector:@selector(orientation) runtime:false];
	[self attemptRotationToDeviceOrientation];
}

- (BOOL)shouldAutorotate {
    UIViewController *visibleController = [self visibleController];
    if ([visibleController conformsToProtocol:@protocol(HTRotateEveryOne)]
        || ([visibleController conformsToProtocol:@protocol(HTRotateEveryOneOnlyIpad)] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)) {
        return true;
    } else if ([visibleController conformsToProtocol:@protocol(HTRotateScrren)]) {
        return [visibleController shouldAutorotate];
    } else {
        return true;
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIViewController *visibleController = [self visibleController];
    if ([visibleController conformsToProtocol:@protocol(HTRotateEveryOne)]
        || ([visibleController conformsToProtocol:@protocol(HTRotateEveryOneOnlyIpad)] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)) {
        return UIInterfaceOrientationMaskAll;
    } else if ([visibleController conformsToProtocol:@protocol(HTRotateScrren)]) {
        return [visibleController supportedInterfaceOrientations];
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    UIViewController *visibleController = [self visibleController];
    if ([visibleController conformsToProtocol:@protocol(HTRotateEveryOne)]
        || ([visibleController conformsToProtocol:@protocol(HTRotateEveryOneOnlyIpad)] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)) {
        return UIInterfaceOrientationPortrait;
    } else if ([visibleController conformsToProtocol:@protocol(HTRotateScrren)]) {
        return [visibleController preferredInterfaceOrientationForPresentation];
    } else {
        return UIInterfaceOrientationPortrait;
    }
}

- (UIViewController *)visibleController {
    UIViewController *visibleController = self;
    while(visibleController.presentedViewController) {
        if ([visibleController conformsToProtocol:@protocol(HTRotateVisible)]) {
            return visibleController;
        }
        visibleController = visibleController.presentedViewController;
    }
    while (visibleController.childViewControllers.count) {
        if ([visibleController conformsToProtocol:@protocol(HTRotateVisible)]) {
            return visibleController;
        }
        if ([visibleController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabBarController = (UITabBarController *)visibleController;
            visibleController = tabBarController.selectedViewController;
        } else if ([visibleController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navigationController = (UINavigationController *)visibleController;
            UIViewController *topViewController = navigationController.topViewController;
            UIViewController *conformRotateVisibleController = [self.class findRotateControllerWithHighController:topViewController];
            if (conformRotateVisibleController) {
                visibleController = conformRotateVisibleController;
            } else {
                visibleController = topViewController;
            }
        } else {
            visibleController = visibleController.childViewControllers.lastObject;
        }
    }
    return visibleController;
}

@end
