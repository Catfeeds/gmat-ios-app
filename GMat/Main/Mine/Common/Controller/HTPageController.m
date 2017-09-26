//
//  HTPageController.m
//  GMat
//
//  Created by hublot on 2016/11/1.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTPageController.h"
#import "HTReuseController.h"
#import "UIScrollView+HTRefresh.h"

@interface HTPageController ()

@end

@implementation HTPageController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.magicView.layoutStyle = VTLayoutStyleDivide;
	self.magicView.sliderStyle = VTSliderStyleDefault;
	self.magicView.separatorColor = [UIColor clearColor];
	self.magicView.sliderColor = [UIColor ht_colorStyle:HTColorStylePrimaryTheme];
	self.magicView.sliderHeight = 1;
	self.magicView.bounces = false;
	self.magicView.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
	self.view.backgroundColor = [UIColor whiteColor];
	
	self.magicView.navigationView.backgroundColor = [UIColor ht_colorString:@"333436"];
	[self.magicView reloadData];
}

- (NSArray <NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
	NSMutableArray *titleArray = [@[] mutableCopy];
	[self.pageModelArray enumerateObjectsUsingBlock:^(HTPageModel *pageModel, NSUInteger index, BOOL * _Nonnull stop) {
		if (pageModel.selectedTitle) {
			[titleArray addObject:pageModel.selectedTitle];
		}
		pageModel.controllerIndex = index;
	}];
	return titleArray;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
	static NSString *itemIdentifier = @"itemIdentifier";
	UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
	if (!menuItem) {
		menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
		[menuItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[menuItem setTitleColor:[UIColor ht_colorStyle:HTColorStylePrimaryTheme] forState:UIControlStateSelected];
		menuItem.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleTitleLarge];
	}
	return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
	Class reuseControllerClass = self.pageModelArray[pageIndex].reuseControllerClass;
	NSString *identifier = NSStringFromClass(reuseControllerClass);
	id controller = [magicView dequeueReusablePageWithIdentifier:identifier];
	if (!controller) {
		controller = [[reuseControllerClass alloc] init];
	}
	return controller;
}

- (void)magicView:(VTMagicView *)magicView viewDidDisappear:(__kindof HTReuseController *)viewController atPage:(NSUInteger)pageIndex {
	HTPageModel *pageModel = self.pageModelArray[pageIndex];
	pageModel.contentOffset = viewController.tableView.contentOffset;
	viewController.pageModel = nil;
}

- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof HTReuseController *)viewController atPage:(NSUInteger)pageIndex {
	__weak HTPageController *weakSelf = self;
    __weak HTReuseController *weakViewController = viewController;
	HTPageModel *pageModel = self.pageModelArray[pageIndex];

	[viewController.tableView ht_setRefreshBlock:^(NSString *pageSize, NSString *currentPage) {
		void(^modelArrayStatus)(NSArray *modelArray, HTError *errorModel) = ^(NSArray *itemArray, HTError *errorModel) {
			if (errorModel.existError) {
				pageModel.noMoreDataSource = [weakViewController.tableView ht_endRefreshWithModelArrayCount:errorModel.errorType];
				return;
			}
			if (itemArray.count) {
				NSMutableArray *modelArray = [itemArray mutableCopy];
				if (currentPage.integerValue == 1) {
					pageModel.modelArray = modelArray;
				} else {
					[pageModel.modelArray addObjectsFromArray:modelArray];
				}
				pageModel.currentPage = currentPage.integerValue;
				pageModel.noMoreDataSource = [weakViewController.tableView ht_endRefreshWithModelArrayCount:modelArray.count];
				weakViewController.pageModel = pageModel;
			} else {
				pageModel.noMoreDataSource = [weakViewController.tableView ht_endRefreshWithModelArrayCount:0];
			}
		};
		if (weakSelf.modelArrayBlock) {
			weakSelf.modelArrayBlock([NSString stringWithFormat:@"%ld", pageIndex], pageSize, currentPage, modelArrayStatus);
		}
	}];
	if (pageModel.modelArray.count) {
		weakViewController.tableView.ht_currentPage = pageModel.currentPage;
		[weakViewController.tableView ht_endRefreshWithModelArrayCount:pageModel.modelArray.count];
		[weakViewController.tableView ht_resetFooterWithDontHaveMoreData:pageModel.noMoreDataSource];
		weakViewController.pageModel = pageModel;
	} else {
		[weakViewController.tableView ht_startRefreshHeader];
	}
	viewController.tableView.contentOffset = pageModel.contentOffset;
}

@end
