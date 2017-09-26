//
//  HTGmatController.m
//  GMat
//
//  Created by hublot on 17/6/4.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTGmatController.h"
#import "THToeflDiscoverController.h"
#import "HTManagerController.h"
#import "HTUserManager.h"
#import "HTCommunityIssueController.h"
#import "THToeflDiscoverIssueController.h"
#import "HTMineFontSizeController.h"
#import <NSObject+HTObjectCategory.h>
#import <UIScrollView+HTRefresh.h>

@interface HTGmatController ()

@end

@implementation HTGmatController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	if (self.tabBarItem.badgeValue.length) {
		[[HTManagerController defaultManagerController].communityController.tableView ht_startRefreshHeader];
		self.tabBarItem.badgeValue = nil;
	}
}

- (void)initializeDataSource {
	
}

- (void)dealRightNavigationButton:(UIButton *)button {
	CGFloat discoverContentOffX = [HTManagerController defaultManagerController].discoverController.discoverContentOffX;
	UIScrollView *scrollView = (UIScrollView *)[self.magicView valueForKey:@"contentView"];
	CGFloat magicContentOffset = scrollView.contentOffset.x;
	CGFloat alpha = 0;
	if (magicContentOffset < HTSCREENWIDTH) {
		alpha = 1 - (magicContentOffset / HTSCREENWIDTH);
	} else if (magicContentOffset >= 2 * HTSCREENWIDTH) {
		alpha = 0;
	} else {
		alpha = discoverContentOffX / HTSCREENWIDTH;
	}
	button.alpha = alpha;
}

- (void)initializeUserInterface {
	
	__weak typeof(self) weakSelf = self;
    self.navigationController.navigationBarHidden = true;
    self.magicView.sliderStyle = VTSliderStyleDefault;
    self.magicView.sliderColor = [UIColor ht_colorStyle:HTColorStylePrimaryTheme];
    self.magicView.sliderHeight = 1;
    self.magicView.navigationInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.magicView.navigationHeight = 64;
    self.magicView.layoutStyle = VTLayoutStyleCenter;
    UIImage *image = [[UIImage imageNamed:@"Toeflbi"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *button = [[UIButton alloc] init];
    [button setImage:image forState:UIControlStateNormal];
    button.tintColor = [UIColor whiteColor];
	[button sizeToFit];
	UIEdgeInsets buttonEdge = UIEdgeInsetsMake(15, 0, 0, 15);
	UIView *contentView = [[UIView alloc] init];
	[contentView addSubview:button];
	contentView.bounds = CGRectMake(0, 0, button.ht_w + buttonEdge.left + buttonEdge.right, button.ht_h + buttonEdge.top + buttonEdge.bottom);
	button.ht_y = buttonEdge.top;
	
	self.magicView.rightNavigatoinItem = contentView;
	
	[[HTManagerController defaultManagerController].discoverController bk_addObserverForKeyPath:NSStringFromSelector(@selector(discoverContentOffX)) options:NSKeyValueObservingOptionInitial task:^(id obj, NSDictionary *change) {
		[weakSelf dealRightNavigationButton:button];
	}];
    
	[self.magicView bk_addObserverForKeyPath:@"contentView.contentOffset" task:^(id target) {
		[weakSelf dealRightNavigationButton:button];
	}];
	
	
    [button ht_whenTap:^(UIView *view) {
        [HTUserManager surePermissionHighOrEqual:HTUserPermissionExerciseAbleUser passCompareBlock:^(HTUser *user) {
            if (self.currentPage == 0) {
				HTCommunityIssueController *issueController = [[HTCommunityIssueController alloc] init];
				[self.navigationController pushViewController:issueController animated:true];
            } else if (self.currentPage == 1) {
				THToeflDiscoverIssueController *issueController = [[THToeflDiscoverIssueController alloc] init];
				[self.navigationController pushViewController:issueController animated:true];
            }
        }];
    } customResponderBlock:^BOOL(UIView *receiveView) {
		return true;
	}];
    
    [self.magicView reloadData];
}

- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    return @[@"吐槽", @"推荐", @"高分故事"];
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    UIButton *menuItem = [super magicView:magicView menuItemAtIndex:itemIndex];
    [menuItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [menuItem setTitleColor:[UIColor ht_colorStyle:HTColorStylePrimaryTheme] forState:UIControlStateSelected];
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageInde {
    UIViewController *viewController;
    switch (pageInde) {
        case 0:
			viewController = [HTManagerController defaultManagerController].communityController;
            break;
        case 1:
			viewController = [HTManagerController defaultManagerController].discoverController;
            break;
        case 2:
            viewController = [HTManagerController defaultManagerController].storyController;
        default:
            
            break;
    }
    viewController.view = viewController.view;
    UITableView *tableView = [viewController ht_valueForSelector:@selector(tableView) runtime:false];
    if (tableView) {
        [[NSNotificationCenter defaultCenter] addObserver:tableView selector:@selector(ht_startRefreshHeader) name:kHTFontChangeNotification object:nil];
    }
    return viewController;
}

@end
