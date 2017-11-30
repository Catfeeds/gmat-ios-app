//
//  HTCourseOnlineVideoFooterView.m
//  GMat
//
//  Created by hublot on 2017/4/19.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTCourseOnlineVideoFooterView.h"
#import "UICollectionView+HTSeparate.h"
#import "HTCourseOnlineVideoCell.h"
#import "HTCourseOnlineVideoModel.h"
#import "HTCourseDetailController.h"

@interface HTCourseOnlineVideoFooterView ()

@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@property (nonatomic, strong) UICollectionView *courseCollectionView;

@end

@implementation HTCourseOnlineVideoFooterView

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor whiteColor];
	[self addSubview:self.segmentedControl];
	[self addSubview:self.courseCollectionView];
	[self reloadSegmentedData];
}

- (void)setModel:(id)model row:(NSInteger)row {
	self.segmentedControl.selectedSegmentIndex = 0;
}

- (void)reloadSegmentedData {
	NSString *selectedKeyString = [NSString stringWithFormat:@"%ld", self.segmentedControl.selectedSegmentIndex];
	NSMutableArray <HTCourseOnlineVideoModel *> *modelArray = [self.onlienVideoDictionary valueForKey:selectedKeyString];
	[self.courseCollectionView ht_updateSection:0 sectionMakerBlock:^(HTCollectionViewSectionMaker *sectionMaker) {
		sectionMaker.modelArray(modelArray);
	}];
	NSInteger rowCount = ceil(modelArray.count / 2.0);
	CGFloat collectionViewHeight = rowCount * 170 + (rowCount - 1) * 10;
	self.courseCollectionView.frame = CGRectMake(0, 30 + 10 + 10, HTSCREENWIDTH, collectionViewHeight);
	self.ht_h = 30 + 10 + collectionViewHeight + 10;
	!self.resetHeightBlock ? : self.resetHeightBlock();
}

- (UISegmentedControl *)segmentedControl {
	if (!_segmentedControl) {
		_segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"直播课", @"视频课"]];
		_segmentedControl.frame = CGRectMake(0, 0, 150, 30);
		_segmentedControl.center = CGPointMake(HTSCREENWIDTH / 2, _segmentedControl.frame.size.height / 2 + 10);
		_segmentedControl.tintColor = [UIColor ht_colorString:@"89d479"];
		
		__weak HTCourseOnlineVideoFooterView *weakSelf = self;
		[_segmentedControl bk_addObserverForKeyPath:@"selectedSegmentIndex" options:NSKeyValueObservingOptionNew task:^(id obj, NSDictionary *change) {
			[weakSelf reloadSegmentedData];
		}];
	}
	return _segmentedControl;
}

- (UICollectionView *)courseCollectionView {
	if (!_courseCollectionView) {
		UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
		_courseCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 30 + 10 + 10, HTSCREENWIDTH, 0) collectionViewLayout:flowLayout];
		_courseCollectionView.scrollEnabled = false;
		CGSize itemSize = CGSizeMake((HTSCREENWIDTH - 10) / 2, 170);
		[_courseCollectionView ht_updateSection:0 sectionMakerBlock:^(HTCollectionViewSectionMaker *sectionMaker) {
			[sectionMaker.cellClass([HTCourseOnlineVideoCell class])
			 .itemSize(itemSize)
			 .itemVerticalSpacing(10)
			 .itemHorizontalSpacing(10) didSelectedCellBlock:^(UICollectionView *collectionView, NSInteger item, __kindof UICollectionViewCell *cell, __kindof HTCourseOnlineVideoModel *model) {
                HTCourseDetailController *detailController = [[HTCourseDetailController alloc] init];
                detailController.courseModel = model;
                [self.ht_controller.navigationController pushViewController:detailController animated:true];
            }];
		}];
	}
	return _courseCollectionView;
}

- (NSMutableDictionary *)onlienVideoDictionary {
	if (!_onlienVideoDictionary) {
		_onlienVideoDictionary = [@{} mutableCopy];
	}
	return _onlienVideoDictionary;
}

@end
