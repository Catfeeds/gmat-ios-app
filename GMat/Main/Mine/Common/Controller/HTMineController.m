//
//  HTMineController.m
//  GMat
//
//  Created by hublot on 16/10/12.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTMineController.h"
#import "UICollectionView+HTSeparate.h"
#import "HTMineHeaderView.h"
#import "HTMineCollectionModel.h"
#import "HTMineCollectionCell.h"
#import "THMinePreferenceController.h"
#import "HTMineScrollView.h"
#import "HTQuestionManager.h"
#import "HTUserManager.h"
#import "HTApplicationHelpManager.h"
#import <UIButton+HTButtonCategory.h>

@interface HTMineController ()

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) HTMineHeaderView *headerView;

@property (nonatomic, strong) HTMineScrollView *headerBezierView;

@end

@implementation HTMineController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[HTUserManager updateUserDetailComplete:^(BOOL success) {
	}];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	self.automaticallyAdjustsScrollViewInsets = false;
	UIImage *image = [[UIImage alloc] init];
	[self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
	[self.navigationController.navigationBar setShadowImage:image];
	self.navigationController.navigationBar.translucent = true;

	
	UIBarButtonItem *preferenceBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"Exercise3"] style:UIBarButtonItemStylePlain handler:^(id sender) {
		THMinePreferenceController *preferenceController = [[THMinePreferenceController alloc] init];
		[self.navigationController pushViewController:preferenceController animated:true];
	}];
	
	UIBarButtonItem *refreshBarButtonItem = [self.class refreshBarButtonItemWithAlertSuperView:self.view];
	self.navigationItem.rightBarButtonItems = @[preferenceBarButtonItem, refreshBarButtonItem];
	[self.view addSubview:self.collectionView];
	self.collectionView.backgroundView = [[UIView alloc] init];
	[self.collectionView.backgroundView addSubview:self.headerBezierView];
	[self.collectionView.backgroundView addSubview:self.headerView];
	
	[HTApplicationHelpManager helpUserToKnowOFFLineExerciseUpdateWithView:refreshBarButtonItem.customView];
	
}

- (HTMineHeaderView *)headerView {
	if (!_headerView) {
		_headerView = [[HTMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.ht_w, self.view.ht_h * 0.43)];
	}
	return _headerView;
}

- (HTMineScrollView *)headerBezierView {
	if (!_headerBezierView) {
		_headerBezierView = [[HTMineScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.ht_w, self.headerView.ht_h)];
		_headerBezierView.backgroundColor = [UIColor whiteColor];
	}
	return _headerBezierView;
}


- (UICollectionView *)collectionView {
	if (!_collectionView) {
		UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
		_collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        [_collectionView ht_updateSection:0 sectionMakerBlock:^(HTCollectionViewSectionMaker *sectionMaker) {
            [sectionMaker.cellClass([HTMineCollectionCell class])
			 .modelArray([HTMineCollectionModel packModelArray])
			 .itemSize(CGSizeMake((_collectionView.ht_w - 1) / 2, (_collectionView.ht_h - self.headerView.ht_h - 49 - 2) / 3))
			 .itemVerticalSpacing(1)
			 .itemHorizontalSpacing(1)
			 .sectionInset(UIEdgeInsetsMake(self.headerView.ht_h, 0, 49, 0)) didSelectedCellBlock:^(UICollectionView *collectionView, NSInteger item, __kindof UICollectionViewCell *cell, __kindof HTMineCollectionModel *model) {
                UIViewController *viewController = [[model.controllerClass alloc] init];
                [self.navigationController pushViewController:viewController animated:true];
            }];
        }];
		_collectionView.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
		_collectionView.alwaysBounceVertical = true;
		[_collectionView bk_addObserverForKeyPath:@"contentOffset" options:NSKeyValueObservingOptionInitial task:^(id obj, NSDictionary *change) {
			if (_collectionView.contentOffset.y < 0) {
				self.headerView.ht_y = self.headerBezierView.ht_y = 0;
				self.headerBezierView.ht_h = self.headerView.ht_h - _collectionView.contentOffset.y;
				CGPoint locationInView = [_collectionView.panGestureRecognizer locationInView:self.headerBezierView];
				self.headerBezierView.pullBlueRect = CGRectMake(self.view.ht_w, self.headerView.ht_h, locationInView.x, self.headerView.ht_h - _collectionView.contentOffset.y * 2);
			} else {
				self.headerView.ht_y = self.headerBezierView.ht_y = - _collectionView.contentOffset.y;
				self.headerBezierView.ht_h = self.headerView.ht_h;
				self.headerBezierView.pullBlueRect = CGRectMake(self.view.ht_w, self.headerBezierView.ht_h, self.view.ht_w, self.headerBezierView.ht_h);
			}
		}];
	}
	return _collectionView;
}

+ (UIBarButtonItem *)refreshBarButtonItemWithAlertSuperView:(UIView *)superView {
	UIButton *refreshButton = [[UIButton alloc] init];
	[refreshButton setTitle:@"同步" forState:UIControlStateNormal];
	[refreshButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	refreshButton.titleLabel.font = [UIFont systemFontOfSize:15];
	
	UIImage *refreshImage = [UIImage imageNamed:@"MinerecordRefresh"];
	refreshImage = [refreshImage ht_resetSize:CGSizeMake(25, 25)];
	[refreshButton setImage:refreshImage forState:UIControlStateNormal];
	[refreshButton ht_makeEdgeWithDirection:HTButtonEdgeDirectionHorizontal imageViewToTitleLabelSpeceOffset:5];
	[refreshButton sizeToFit];
	[[HTUserManager defaultUserManager] bk_addObserverForKeyPath:@"synchronousExerciseRecord" options:NSKeyValueObservingOptionInitial task:^(id obj, NSDictionary *change) {
		NSString *animationKeyString = @"refresh";
		if ([HTUserManager defaultUserManager].synchronousExerciseRecord && ![refreshButton.layer animationForKey:animationKeyString]) {
			CABasicAnimation *refreshAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
			refreshAnimation.toValue = @(M_PI * 2);
			refreshAnimation.duration = 1;
			refreshAnimation.cumulative = true;
			refreshAnimation.repeatCount = true;
			[refreshButton.imageView.layer addAnimation:refreshAnimation forKey:animationKeyString];
		} else {
			if (![HTUserManager defaultUserManager].synchronousExerciseRecord) {
				[refreshButton.imageView.layer removeAllAnimations];
			}
		}
	}];
	[refreshButton ht_whenTap:^(UIView *view) {
		[[HTUserManager defaultUserManager] startSynchronousExerciseRecordCompleteHandleBlock:^(NSString *errorString) {
			[HTAlert circleTitle:errorString superView:superView];
		}];
	}];
	UIBarButtonItem *refreshBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
	return refreshBarButtonItem;
}

@end
