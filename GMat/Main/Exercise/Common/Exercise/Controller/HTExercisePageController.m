//
//  HTExercisePageController.m
//  GMat
//
//  Created by hublot on 2017/5/8.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTExercisePageController.h"
#import "HTMagicDelegate.h"
#import "HTReuseController.h"
#import "UIScrollView+HTRefresh.h"

@interface HTExercisePageController ()

@property (nonatomic, strong) VTMagicView *menuBarMagicView;

@property (nonatomic, strong) HTMagicDelegate *magicBlockDelegate;

@property (nonatomic, strong) NSMutableDictionary <NSString *, HTPageModel *> *pageModelDictionary;

@end

@implementation HTExercisePageController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self.view addSubview:self.menuBarMagicView];
    [self.menuBarMagicView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(44);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
    }];
}

- (NSArray <NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
	if (!self.pageModelDictionary) {
		self.pageModelDictionary = [@{} mutableCopy];
		for (NSInteger index = 0; index < self.firstRowTitleArray.count; index ++) {
			for (NSInteger jump = 0; jump < self.secondRowTitleArray.count; jump ++) {
				NSString *pageModelKeyString = [self pageModelKeyStringFromFirstSelectedIndex:index secondSelectedIndex:jump];
				HTPageModel *pageModel = [[HTPageModel alloc] init];
				[self.pageModelDictionary setValue:pageModel forKey:pageModelKeyString];
			}
		}
	}
	return self.firstRowTitleArray;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
	Class reuseControllerClass = self.reuseControllerClass;
	NSString *identifier = NSStringFromClass(reuseControllerClass);
	HTReuseController *controller = [magicView dequeueReusablePageWithIdentifier:identifier];
	if (!controller) {
		controller = [[reuseControllerClass alloc] init];
		[controller.view addSubview:controller.tableView];
        [controller.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(44, 0, 0, 0));
        }];
//		controller.tableView.ht_h -= 44;
//		controller.tableView.ht_y += 44;
	}
	return controller;
}

- (void)magicView:(VTMagicView *)magicView viewDidDisappear:(__kindof HTReuseController *)viewController atPage:(NSUInteger)pageIndex {
	HTPageModel *pageModel = [self pageModelFromFirstSelectedIndex:pageIndex];
	pageModel.contentOffset = viewController.tableView.contentOffset;
	viewController.pageModel = nil;
}

- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof HTReuseController *)viewController atPage:(NSUInteger)pageIndex {
	__weak HTExercisePageController *weakSelf = self;
	__weak HTReuseController *weakViewController = viewController;
	HTPageModel *pageModel = [self pageModelFromFirstSelectedIndex:pageIndex];
	
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
			weakSelf.modelArrayBlock([NSString stringWithFormat:@"%ld", pageIndex], [NSString stringWithFormat:@"%ld", weakSelf.magicBlockDelegate.selectedIndex], pageSize, currentPage, modelArrayStatus);
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

- (VTMagicView *)menuBarMagicView {
	if (!_menuBarMagicView) {
		_menuBarMagicView = [[VTMagicView alloc] init];
		_menuBarMagicView.navigationColor = [UIColor ht_colorString:@"333436"];
		_menuBarMagicView.layoutStyle = VTLayoutStyleDivide;
		_menuBarMagicView.sliderStyle = VTSliderStyleBubble;
		_menuBarMagicView.delegate = self.magicBlockDelegate;
		_menuBarMagicView.dataSource = self.magicBlockDelegate;
		_menuBarMagicView.separatorColor = [UIColor clearColor];
		_menuBarMagicView.bubbleRadius = 3;
		_menuBarMagicView.bubbleInset = UIEdgeInsetsMake(5, 10, 5, 10);
		_menuBarMagicView.sliderColor = [UIColor ht_colorString:@"1f1f1f"];
		_menuBarMagicView.bounces = false;
		[_menuBarMagicView reloadData];
	}
	return _menuBarMagicView;
}

- (HTMagicDelegate *)magicBlockDelegate {
	if (!_magicBlockDelegate) {
		
		__weak HTExercisePageController *weakSelf = self;
		_magicBlockDelegate = [[HTMagicDelegate alloc] initWithTitleArray:self.secondRowTitleArray menuItemBlock:^UIButton *(VTMagicView *magicView, NSUInteger itemIndex) {
			static NSString *itemIdentifier = @"itemIdentifier";
			UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
			if (!menuItem) {
				menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
				[menuItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
				[menuItem setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
				menuItem.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleTitleLarge];
			}
			return menuItem;
		} didSelectedBlock:^(VTMagicView *magicView, NSUInteger itemIndex) {
			[weakSelf.magicView reloadData];
		}];

	}
	return _magicBlockDelegate;
}

- (NSArray *)firstRowTitleArray {
	if (!_firstRowTitleArray) {
		_firstRowTitleArray = @[@"讲义", @"OG", @"PREP", @"GWD", @"Manhattan"];
	}
	return _firstRowTitleArray;
}

- (NSArray *)secondRowTitleArray {
	if (!_secondRowTitleArray) {
		_secondRowTitleArray = @[@"SC", @"CR", @"RC", @"PS", @"DS"];
	}
	return _secondRowTitleArray;
}

- (NSString *)pageModelKeyStringFromFirstSelectedIndex:(NSInteger)firstSelectedIndex secondSelectedIndex:(NSInteger)secondSelectedIndex {
	NSString *pageModelDictionaryKeyString = [NSString stringWithFormat:@"%ld-%ld", firstSelectedIndex, secondSelectedIndex];
	return pageModelDictionaryKeyString;
}

- (HTPageModel *)pageModelFromFirstSelectedIndex:(NSInteger)firstSelectedIndex {
	NSString *pageModelDictionaryKeyString = [self pageModelKeyStringFromFirstSelectedIndex:firstSelectedIndex secondSelectedIndex:self.magicBlockDelegate.selectedIndex];
	HTPageModel *pageModel = [self.pageModelDictionary valueForKey:pageModelDictionaryKeyString];
	return pageModel;
}

- (void)reloadMagicView {
    self.pageModelDictionary = nil;
    [self.magicView reloadData];
}

@end
