//
//  VTMagicController.m
//  VTMagicView
//
//  Created by tianzhuo on 14-11-11.
//  Copyright (c) 2014年 tianzhuo. All rights reserved.
//

#import "VTMagicController.h"

@interface VTMagicController ()

// 解决过早 reloadData 导致的 item 不能重用
@property (nonatomic, assign) BOOL superHasReloadMagicView;

@end

@implementation VTMagicController

#pragma mark - Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        } else if ([self respondsToSelector:@selector(setWantsFullScreenLayout:)]) {
            [self setValue:@YES forKey:@"wantsFullScreenLayout"];
        }
    }
    return self;
}

- (void)loadView {
    [super loadView];
	self.view = self.magicView;
	self.magicView.layoutStyle = VTLayoutStyleDivide;
	self.magicView.sliderStyle = VTSliderStyleBubble;
	self.magicView.separatorColor = [UIColor clearColor];
	self.magicView.bubbleRadius = 3;
	self.magicView.bubbleInset = UIEdgeInsetsMake(5, 10, 5, 10);
	self.magicView.sliderColor = [UIColor ht_colorString:@"1f1f1f"];
	self.magicView.navigationView.backgroundColor = [UIColor ht_colorString:@"333436"];
	self.magicView.bounces = false;
	/**
	 * MARK: 设置头部的 bounces
	 */
	UIScrollView *scrollView = [self.magicView valueForKey:@"menuBar"];
	scrollView.bounces = false;
}

- (void)viewWillAppear:(BOOL)animated {
	
    [super viewWillAppear:animated];
	
	/**
	 * MARK: 解决过早 reloadData 导致的 item 不能重用
	 */
	if (!self.superHasReloadMagicView) {
		[self.magicView reloadData];
	}
	self.superHasReloadMagicView = true;
	
    _appearanceState = VTAppearanceStateWillAppear;
    if (!_magicView.isSwitching) {
        [_currentViewController beginAppearanceTransition:YES animated:animated];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _appearanceState = VTAppearanceStateDidAppear;
    if (!_magicView.isSwitching) {
        [_currentViewController endAppearanceTransition];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	
    _appearanceState = VTAppearanceStateWillDisappear;
    if (!_magicView.isSwitching) {
        [_currentViewController beginAppearanceTransition:NO animated:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _appearanceState = VTAppearanceStateDidDisappear;
    if (!_magicView.isSwitching) {
        [_currentViewController endAppearanceTransition];
    }
}

#pragma mark - 禁止自动触发appearance methods
- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

#pragma mark - functional methods
- (UIViewController *)viewControllerAtPage:(NSUInteger)pageIndex {
    return [self.magicView viewControllerAtPage:pageIndex];
}

- (void)switchToPage:(NSUInteger)pageIndex animated:(BOOL)animated {
    [self.magicView switchToPage:pageIndex animated:animated];
}

#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    return nil;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
	static NSString *itemIdentifier = @"itemIdentifier";
	UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
	if (!menuItem) {
		menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
		[menuItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[menuItem setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
		menuItem.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleTitleLarge];
	}
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageInde {
    return nil;
}

#pragma mark - VTMagicViewDelegate
- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
	
}

- (void)magicView:(VTMagicView *)magicView viewDidDisappear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    VTLog(@"index:%ld viewControllerDidDisappear:%@", (long)pageIndex, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex {
    VTLog(@"didSelectItemAtIndex:%ld", (long)itemIndex);
}

#pragma mark - accessor methods
- (VTMagicView *)magicView {
    if (!_magicView) {
        _magicView = [[VTMagicView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _magicView.autoresizesSubviews = YES;
        _magicView.magicController = self;
        _magicView.delegate = self;
        _magicView.dataSource = self;
        [self.view setNeedsLayout];
    }
    return _magicView;
}

- (NSArray<UIViewController *> *)viewControllers {
    return self.magicView.viewControllers;
}

@end
