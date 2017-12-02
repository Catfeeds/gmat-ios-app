//
//  HTTabBarController.m
//  GMat
//
//  Created by hublot on 16/10/11.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTTabBarController.h"
#import "HTRootNavigationController.h"
#import "HTTabBar.h"
#import "HTExerciseController.h"
#import "HTKnowledgeController.h"
#import "HTGmatController.h"
#import "HTCourseController.h"
#import "HTMineController.h"
#import "HTManagerController.h"


#define CONTROLLERKEY			@"controllerKey"
#define TITLEKEY				@"titleKey"
#define IMAGEKEY				@"imageKey"
#define SELECTEDIMAGEKEY		@"selectedImageKey"




@interface HTTabBarController ()

@end

@implementation HTTabBarController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	HTTabBar *tabBar = [[HTTabBar alloc] init];
	[self setValue:tabBar forKey:@"tabBar"];

	NSArray *childArray = @[@{CONTROLLERKEY:NSStringFromClass([HTCourseController class]),
							  TITLEKEY:@"抢先学课",
							  IMAGEKEY:@"TabbarItem1",
							  SELECTEDIMAGEKEY:@"TabbarItem1-1"},
  							@{CONTROLLERKEY:NSStringFromClass([HTExerciseController class]),
							  TITLEKEY:@"做题模考",
							  IMAGEKEY:@"TabbarItem2",
							  SELECTEDIMAGEKEY:@"TabbarItem2-1"},
							@{CONTROLLERKEY:NSStringFromClass([HTGmatController class]),
							  TITLEKEY:@"雷哥社区",
							  IMAGEKEY:@"TabbarItem3",
							  SELECTEDIMAGEKEY:@"TabbarItem3-1"},
							@{CONTROLLERKEY:NSStringFromClass([HTKnowledgeController class]),
							  TITLEKEY:@"小讲堂",
							  IMAGEKEY:@"TabbarItem4",
							  SELECTEDIMAGEKEY:@"TabbarItem4-1"},
							@{CONTROLLERKEY:NSStringFromClass([HTMineController class]),
							  TITLEKEY:@"学习记录",
							  IMAGEKEY:@"TabbarItem5",
							  SELECTEDIMAGEKEY:@"TabbarItem5-1"}];
	
	[childArray enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger index, BOOL * _Nonnull stop) {
		[self addChildViewControllerWithChildDictionary:dictionary];
	}];
}

- (void)addChildViewControllerWithChildDictionary:(NSDictionary *)dictionary {
	UIViewController *viewController = [[NSClassFromString(dictionary[CONTROLLERKEY]) alloc] init];
	HTRootNavigationController *navigationController = [[HTRootNavigationController alloc] initWithRootViewController:viewController];
	viewController.tabBarItem.title = dictionary[TITLEKEY];
	viewController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3);
	[viewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorString:@"7c7f7f"]} forState:UIControlStateNormal];
	[viewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorString:@"2298ff"]} forState:UIControlStateSelected];
	viewController.tabBarItem.image = [[[UIImage imageNamed:dictionary[IMAGEKEY]] ht_resetSizeZoomNumber:0.6] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	viewController.tabBarItem.selectedImage = [[[UIImage imageNamed:dictionary[SELECTEDIMAGEKEY]] ht_resetSizeZoomNumber:0.6] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	[super addChildViewController:navigationController];
}

- (void)setSelectedViewController:(__kindof UIViewController *)selectedViewController {
	if ([selectedViewController isKindOfClass:[HTRootNavigationController class]]) {
		HTRootNavigationController *rootNavigationController = (HTRootNavigationController *)selectedViewController;
		if ([rootNavigationController.topViewController isKindOfClass:[RTContainerController class]]) {
			RTContainerController *containerController = (RTContainerController *)rootNavigationController.topViewController;
			UIViewController *contentViewController = containerController.contentViewController;
			if ([contentViewController isKindOfClass:[HTGmatController class]]) {
//				HTGmatController *gmatController = (HTGmatController *)contentViewController;
//
//				UIButton *contentView = [[UIButton alloc] init];
//				CGSize hamburgerSize = self.hamburgerButton.ht_size;
//				CGSize contentSize = CGSizeMake(hamburgerSize.width * 2, hamburgerSize.height * 2);
//				contentView.bounds = CGRectMake(0, - HTADAPT568(8), contentSize.width, contentSize.height);
//				contentView.ht_size = contentSize;
//				[contentView addSubview:self.hamburgerButton];
//				gmatController.magicView.leftNavigatoinItem = contentView;
			} else {
				contentViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.hamburgerButton];
			}
		}
	}
	[super setSelectedViewController:selectedViewController];
}

- (THHamburgerButton *)hamburgerButton {
	if (!_hamburgerButton) {
		_hamburgerButton = [[THHamburgerButton alloc] initWithFrame:CGRectMake(0, 0, 54, 54)];
		_hamburgerButton.transform = CGAffineTransformMakeScale(HTADAPT568(0.35), HTADAPT568(0.35));
        
        __weak THHamburgerButton *weakButton = _hamburgerButton;
		[_hamburgerButton ht_whenTap:^(UIView *view) {
			weakButton.showMenu = true;
			[[HTManagerController defaultManagerController].drawerController switchDrawerState];
		}];
	}
	return _hamburgerButton;
}

@end
