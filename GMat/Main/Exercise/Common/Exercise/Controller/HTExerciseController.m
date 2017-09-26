//
//  HTExerciseController.m
//  GMat
//
//  Created by hublot on 16/10/12.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTExerciseController.h"
#import "UICollectionView+HTSeparate.h"
#import "HTExerciseCollectionCell.h"
#import "HTExerciseCollectionModel.h"
#import "HTLoginManager.h"
#import "THMinePreferenceController.h"
#import "HTScoreController.h"
#import "HTQuestionController.h"
#import "HTExerciseHeaderView.h"
#import "HTExerciseQuestionCountModel.h"
#import "HTMineController.h"
#import "HTQuestionManager.h"
#import "HTSqliteUpdateManager.h"
#import "HTSqliteUpdateView.h"
#import "HTSqliteUpdateFireView.h"
#import "HTActivityModel.h"
#import <HTEncodeDecodeManager.h>
#import "HTActivityManager.h"
#import "HTActivityAlertView.h"

@interface HTExerciseController ()

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) HTExerciseHeaderView *headerView;

@end

static CGFloat kHTExerciseHeaderHeight = 0.6;

@implementation HTExerciseController

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self requestQuestionCount];
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
	
	UIBarButtonItem *preferenceBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[[UIImage imageNamed:@"Exercise3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain handler:^(id sender) {
		THMinePreferenceController *preferenceController = [[THMinePreferenceController alloc] init];
		[self.navigationController pushViewController:preferenceController animated:true];
	}];
	
	UIBarButtonItem *refreshBarButtonItem = [HTMineController refreshBarButtonItemWithAlertSuperView:self.view];
	
	self.navigationItem.rightBarButtonItems = @[preferenceBarButtonItem, refreshBarButtonItem];
	[self.view addSubview:self.collectionView];
	[self.collectionView addSubview:self.headerView];
	
	
	//-----------------------------------------/ 题库更新 /-----------------------------------------//
	[HTSqliteUpdateManager valiteSqliteUpdateComplete:^(BOOL show) {
		if (show) {
			[HTSqliteUpdateView showUpdateAlertViewInSuperView:self.view sureButtonBlock:^(HTSqliteUpdateView *updateView) {
				[HTQuestionManager downloadUpdateSqliteStartHandleBlock:^{
					[HTSqliteUpdateFireView showUpdateFireView];
				} progressHandleBlock:^(float progress, float completedMegaByte, float totalMegaByte) {
					[HTSqliteUpdateFireView setProgress:progress];
				} completeHandleBlock:^(NSString *errorString) {
                    [HTAlert title:errorString.length ? errorString : @"更新成功 !"];
                    [HTSqliteUpdateFireView removeUpdateAlerView];
                    [HTSqliteUpdateView removeUpdateAlerView];
				}];
			}];
		}
	}];
	
	//-----------------------------------------/ 最新活动 /-----------------------------------------//
	
	[HTRequestManager requestActivityComplete:^(id response, HTError *errorModel) {
		if (errorModel.existError) {
			return;
		}
		HTActivityModel *activityModel = [HTActivityModel mj_objectWithKeyValues:response];
		NSData *data = [HTEncodeDecodeManager ht_decodeWithBase64:activityModel.ht_image_64];
		UIImage *image = [UIImage imageWithData:data];
		if (image.size.width > 0 && image.size.height > 0) {
			NSString *activityIdString = [NSString stringWithFormat:@"%ld", activityModel.ID];
			BOOL display = [HTActivityManager valiteShouldDisplayActivityWithActivityIdString:activityIdString maxDisplayCount:activityModel.maxdisplay];
			if (display) {
				[HTActivityAlertView showActivityWithAnimated:true image:image url:activityModel.url superView:self.view];
				[HTActivityManager appendActivityHistoryWithActivityIdString:activityIdString];
			}
		}
	}];

}

- (void)requestQuestionCount {
	HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
	networkModel.autoAlertString = nil;
	networkModel.offlineCacheStyle = HTCacheStyleAllUser;
	networkModel.autoShowError = false;
	[HTRequestManager requestExerciseQuestionCountWithNetworkModel:networkModel complete:^(id response, HTError *errorModel) {
		HTExerciseQuestionCountModel *countModel = [HTExerciseQuestionCountModel mj_objectWithKeyValues:response];
        if (!countModel) {
            countModel = [[HTExerciseQuestionCountModel alloc] init];
        }
		[self.headerView.exerciseCountView setModel:countModel row:0];
	}];
}

- (UICollectionView *)collectionView {
	if (!_collectionView) {
		UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
		_collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
		
		UIEdgeInsets sectionInset = UIEdgeInsetsMake(self.headerView.ht_h, HTADAPT568(12), HTADAPT568(12), HTADAPT568(12));
		CGFloat horizontalSpacing = HTADAPT568(12);
		CGFloat verticalSpacing = HTADAPT568(12);
		CGSize itemSize = CGSizeMake((HTSCREENWIDTH - horizontalSpacing * 4) / 3 - 2, (_collectionView.ht_h - self.headerView.ht_h - 49 - HTADAPT568(12) * 2) / 2);
		
        [_collectionView ht_updateSection:0 sectionMakerBlock:^(HTCollectionViewSectionMaker *sectionMaker) {
            [[sectionMaker.cellClass([HTExerciseCollectionCell class])
			  .modelArray([HTExerciseCollectionModel packModelArray])
			  .itemSize(itemSize)
			  .itemHorizontalSpacing(horizontalSpacing)
			  .itemVerticalSpacing(verticalSpacing)
			  .sectionInset(sectionInset) didSelectedCellBlock:^(UICollectionView *collectionView, NSInteger item, __kindof UICollectionViewCell *cell, __kindof HTExerciseCollectionModel *model) {
                if (model.modelType == HTExerciseCollectionModelTypeReport) {
                    if ([HTUserManager currentUser].permission >= HTUserPermissionExerciseAbleUser) {
                        UIViewController *viewController = [[model.controllerClass alloc] init];
                        [self.navigationController pushViewController:viewController animated:true];
                    } else {
//                        if ([HTUserManager currentUser].permission == HTUserPermissionExerciseNotFullThreeUser) {
//                            [HTAlert title:@"亲呀!" message:@"需要先完善手机号或者邮箱哦😲" tryAgainTitle:@"确定"  tryAgainBlock:^{
//								THMinePreferenceController *preferenceController = [[THMinePreferenceController alloc] init];
//								[self.navigationController pushViewController:preferenceController animated:true];
//                            }];
//                        } else {
                            [HTAlert title:@"亲呀!" message:@"要登录才给看喔!" tryAgainTitle:@"立即登录"  tryAgainBlock:^{
                                [HTLoginManager presentAndLoginSuccess:^{
									UIViewController *viewController = [[model.controllerClass alloc] init];
									[self.navigationController pushViewController:viewController animated:true];
								}];
                            }];
//                        }
                    }
                } else {
                    UIViewController *viewController = [[model.controllerClass alloc] init];
                    [self.navigationController pushViewController:viewController animated:true];
                }
            }] didScrollBlock:^(UIScrollView *scrollView, CGPoint contentOffSet, UIEdgeInsets contentInSet) {
				CGRect frame = self.headerView.frame;
				CGFloat maxHeight = self.headerView.exerciseSearchView.ht_h + 64 + 30;
				frame.size.height = MAX(maxHeight, self.view.bounds.size.height * kHTExerciseHeaderHeight - contentOffSet.y);
				
				CGRect bounds = scrollView.bounds;
				bounds.origin.y = self.view.bounds.size.height * kHTExerciseHeaderHeight - frame.size.height;
				scrollView.bounds = bounds;
				frame.origin.y = scrollView.bounds.origin.y;
				self.headerView.frame = frame;
	
				[self.headerView.exerciseCountView setNeedsDisplay];
				self.headerView.exerciseCountView.blurProgress = (contentOffSet.y * 2) / (self.view.bounds.size.height * kHTExerciseHeaderHeight);
			}];
        }];
		_collectionView.alwaysBounceVertical = true;
		_collectionView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ExerciseIndexBackground"]];
		_collectionView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
	}
	return _collectionView;
}

- (HTExerciseHeaderView *)headerView {
	if (!_headerView) {
		_headerView = [[HTExerciseHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height * kHTExerciseHeaderHeight)];
		_headerView.exerciseCountView.blurProgress = 0;
		_headerView.clipsToBounds = true;
	}
	return _headerView;
}

@end
