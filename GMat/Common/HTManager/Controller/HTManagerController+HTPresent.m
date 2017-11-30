//
//  HTManagerController+HTPresent.m
//  GMat
//
//  Created by hublot on 2017/7/14.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTManagerController+HTPresent.h"
#import <NSObject+HTObjectCategory.h>

@implementation UIViewController (HTPresentController)

+ (void)load {
	[self ht_swizzInstanceNativeSelector:@selector(dismissViewControllerAnimated:completion:) customSelector:@selector(ht_dismissViewControllerAnimated:completion:)];
}

- (void)ht_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
	UIViewController *presentedController = self;
	if (self.presentedViewController) {
		presentedController = self.presentedViewController;
	}
	[self ht_dismissViewControllerAnimated:flag completion:^{
		if (completion) {
			completion();
		}
		if (presentedController.ht_dismissComplete) {
			presentedController.ht_dismissComplete();
		}
	}];
}

- (void (^)(void))ht_dismissComplete {
	return [self ht_valueForSelector:@selector(ht_dismissComplete) runtime:true];
}

- (void)setHt_dismissComplete:(void (^)(void))ht_dismissComplete {
	[self ht_setValue:ht_dismissComplete forSelector:@selector(ht_dismissComplete) runtime:true];
}

- (BOOL)ht_presentAnimation {
	return [[self ht_valueForSelector:@selector(ht_presentAnimation) runtime:true] boolValue];
}

- (void)setHt_presentAnimation:(BOOL)ht_presentAnimation {
	[self ht_setValue:@(ht_presentAnimation) forSelector:@selector(ht_presentAnimation) runtime:true];
}

- (void (^)(void))ht_presentComplete {
	return [self ht_valueForSelector:@selector(ht_presentComplete) runtime:true];
}

- (void)setHt_presentComplete:(void (^)(void))ht_presentComplete {
	[self ht_setValue:ht_presentComplete forSelector:@selector(ht_presentComplete) runtime:true];
}

@end









@interface HTManagerController ()

@property (nonatomic, strong) NSMutableArray <UIViewController *> *willPresentArray;

@end

@implementation HTManagerController (HTPresent)

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
	if (self.presentedViewController) {
		[viewControllerToPresent setHt_presentAnimation:flag];
		[viewControllerToPresent setHt_presentComplete:completion];
		[self.willPresentArray addObject:viewControllerToPresent];
	} else {
		__weak typeof(viewControllerToPresent) weakPresent = viewControllerToPresent;
		[viewControllerToPresent setHt_dismissComplete:^{
			if ([self.willPresentArray containsObject:weakPresent]) {
				[self.willPresentArray removeObject:weakPresent];
			}
			UIViewController *willPresentController = self.willPresentArray.firstObject;
			if (willPresentController) {
				[self presentViewController:willPresentController animated:willPresentController.ht_presentAnimation completion:willPresentController.ht_presentComplete];
			}
		}];
		[super presentViewController:viewControllerToPresent animated:flag completion:completion];
	}
}

- (void)setWillPresentArray:(NSMutableArray<UIViewController *> *)willPresentArray {
	[self ht_setValue:willPresentArray forSelector:@selector(willPresentArray) runtime:true];
}

- (NSMutableArray<UIViewController *> *)willPresentArray {
	NSMutableArray <UIViewController *> *willPresentArray = [self ht_valueForSelector:@selector(willPresentArray) runtime:true];
	if (!willPresentArray) {
		willPresentArray = [@[] mutableCopy];
		self.willPresentArray = willPresentArray;
	}
	return willPresentArray;
}

@end
