//
//  HTCourseOnlineVideoIndexCell.m
//  GMat
//
//  Created by hublot on 2017/5/24.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTCourseOnlineVideoIndexCell.h"
#import <UICollectionView+HTSeparate.h>
#import "HTCourseOnlineVideoCell.h"
#import "HTCourseDetailController.h"
#import <NSObject+HTTableRowHeight.h>

@interface HTCourseOnlineVideoIndexCell ()

@property (nonatomic, strong) UICollectionView *courseCollectionView;

@property (nonatomic, strong) NSArray *model;

@end

@implementation HTCourseOnlineVideoIndexCell

- (void)didMoveToSuperview {
	[self addSubview:self.courseCollectionView];
}

- (void)setModel:(NSArray <HTCourseOnlineVideoModel *> *)model row:(NSInteger)row {
	if (model == _model) {
		return;
	}
	_model = model;
	NSArray <HTCourseOnlineVideoModel *> *modelArray = model;
	[self.courseCollectionView ht_updateSection:0 sectionMakerBlock:^(HTCollectionViewSectionMaker *sectionMaker) {
		sectionMaker.modelArray(modelArray);
	}];
	self.courseCollectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
	CGFloat modelHeight = self.courseCollectionView.bounds.size.height;
	[model ht_setRowHeightNumber:@(modelHeight) forCellClass:self.class];
}

- (UICollectionView *)courseCollectionView {
	if (!_courseCollectionView) {
		UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
		flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		CGSize itemSize = CGSizeMake((HTSCREENWIDTH - 10) / 1.7, HTADAPT568(140));
		_courseCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, HTSCREENWIDTH, itemSize.height) collectionViewLayout:flowLayout];
		[_courseCollectionView ht_updateSection:0 sectionMakerBlock:^(HTCollectionViewSectionMaker *sectionMaker) {
			[sectionMaker.cellClass([HTCourseOnlineVideoCell class])
			 .itemSize(itemSize)
			 .itemVerticalSpacing(10) didSelectedCellBlock:^(UICollectionView *collectionView, NSInteger item, __kindof UICollectionViewCell *cell, __kindof HTCourseOnlineVideoModel *model) {
				 HTCourseDetailController *detailController = [[HTCourseDetailController alloc] init];
				 detailController.courseModel = model;
				 [self.ht_controller.navigationController pushViewController:detailController animated:true];
			 }];
		}];
	}
	return _courseCollectionView;
}

@end
