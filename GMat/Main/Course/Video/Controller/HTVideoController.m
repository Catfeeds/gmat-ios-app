//
//  HTVideoController.m
//  GMat
//
//  Created by hublot on 16/10/13.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTVideoController.h"
#import "UICollectionView+HTSeparate.h"
#import "HTCourseOnlineVideoModel.h"
#import "HTOnlineHeaderView.h"
#import "HTOnlineCollectionCell.h"
#import "UIScrollView+HTRefresh.h"
#import "HTCourseDetailController.h"

@interface HTVideoController ()

@property (nonatomic, strong) NSMutableArray *modelArray;

@property (nonatomic, strong) HTOnlineHeaderView *headerView;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

static NSString *videoHeaderCourse = @"310";

@implementation HTVideoController

- (void)dealloc {
    
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
    __weak HTVideoController *weakSelf = self;
	[self.collectionView ht_setRefreshBlock:^(NSString *pageSize, NSString *currentPage) {
		HTNetworkModel *networkModel = [HTNetworkModel modelForOnlyCacheNoInterfaceForScrollViewWithCacheStyle:HTCacheStyleAllUser];
		[HTRequestManager requestVideoCourseWithNetworkModel:networkModel complete:^(id response, HTError *errorModel) {
			if (errorModel.existError) {
				[weakSelf.collectionView ht_endRefreshWithModelArrayCount:errorModel.errorType];
				return;
			}
			NSMutableArray *modelArray = [HTCourseOnlineVideoModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
			if (currentPage.integerValue == 1) {
				NSMutableArray *tempHeaderModelArray = [modelArray mutableCopy];
				[modelArray enumerateObjectsUsingBlock:^(HTCourseOnlineVideoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
					if ([obj.contentid isEqualToString:videoHeaderCourse]) {
						[tempHeaderModelArray removeObject:obj];
						[weakSelf.headerView setModel:obj section:0];
						[weakSelf.headerView ht_whenTap:^(UIView *view) {
							HTCourseDetailController *detailController = [[HTCourseDetailController alloc] init];
							detailController.courseModel = obj;
							[weakSelf.navigationController pushViewController:detailController animated:true];
						}];
						*stop = true;
					}
				}];
				weakSelf.modelArray = tempHeaderModelArray;
			} else {
				[weakSelf.modelArray addObjectsFromArray:modelArray];
			}
			[weakSelf.collectionView ht_endRefreshWithModelArrayCount:modelArray.count];
			[weakSelf.collectionView ht_updateSection:0 sectionMakerBlock:^(HTCollectionViewSectionMaker *sectionMaker) {
				sectionMaker.modelArray(weakSelf.modelArray);
			}];
		}];
	}];
	[self.collectionView ht_startRefreshHeader];
}

- (void)initializeUserInterface {
	self.navigationItem.title = @"视频课";
	[self.view addSubview:self.collectionView];
	[self.collectionView addSubview:self.headerView];
	self.collectionView.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
}

- (NSMutableArray *)modelArray {
	if (!_modelArray) {
		_modelArray = [@[] mutableCopy];
	}
	return _modelArray;
}


- (UICollectionView *)collectionView {
	if (!_collectionView) {
		UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
		_collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        __weak HTVideoController *weakSelf = self;
        [_collectionView ht_updateSection:0 sectionMakerBlock:^(HTCollectionViewSectionMaker *sectionMaker) {
            [sectionMaker.cellClass([HTOnlineCollectionCell class])
			 .sectionInset(UIEdgeInsetsMake(weakSelf.headerView.ht_h + 30, 15, 15, 15))
			 .itemSize(CGSizeMake((weakSelf.view.ht_w - 15 * 3) / 2, HTADAPT568(140)))
			 .itemHorizontalSpacing(15)
			 .itemVerticalSpacing(15) didSelectedCellBlock:^(UICollectionView *collectionView, NSInteger item, __kindof UICollectionViewCell *cell, __kindof NSObject *model) {
                HTCourseDetailController *detailController = [[HTCourseDetailController alloc] init];
                detailController.courseModel = model;
                [weakSelf.navigationController pushViewController:detailController animated:true];
            }];
        }];
	}
	return _collectionView;
}

- (HTOnlineHeaderView *)headerView {
	if (!_headerView) {
		_headerView = [[HTOnlineHeaderView alloc] initWithFrame:CGRectMake(15, 15, self.view.ht_w - 30, HTADAPT568(180))];
		_headerView.layer.cornerRadius = 3;
		_headerView.layer.masksToBounds = true;
	}
	return _headerView;
}

@end
