//
//  HTCourseHotIndexCell.m
//  GMat
//
//  Created by hublot on 2017/4/19.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTCourseHotIndexCell.h"
#import "HTCourseHotCell.h"
#import "UICollectionView+HTSeparate.h"
#import "HTCourseOnlineVideoModel.h"
#import "HTCourseHotModel.h"
#import "HTCourseDetailController.h"
#import "HTRandomNumberManager.h"
#import "UICollectionViewCell+HTSeparate.h"
#import <NSObject+HTTableRowHeight.h>

@interface HTCourseHotIndexCell ()

@property (nonatomic, strong) UICollectionView *courseHotCollectionView;

@property (nonatomic, strong) NSArray *model;

@end

@implementation HTCourseHotIndexCell

- (void)didMoveToSuperview {
	[self addSubview:self.courseHotCollectionView];
}

- (void)setModel:(NSArray *)model row:(NSInteger)row {
    if (model == _model) {
        return;
    }
    _model = model;
	NSArray *modelArray = model;
	[self.courseHotCollectionView ht_updateSection:0 sectionMakerBlock:^(HTCollectionViewSectionMaker *sectionMaker) {
		sectionMaker.modelArray(modelArray);
	}];
	self.courseHotCollectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
	
    CGFloat modelHeight = self.courseHotCollectionView.frame.size.height;
    [model ht_setRowHeightNumber:@(modelHeight) forCellClass:self.class];
}

- (UICollectionView *)courseHotCollectionView {
	if (!_courseHotCollectionView) {
		UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
		flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		CGSize itemSize = CGSizeMake((HTSCREENWIDTH - 10) / 1.7, HTADAPT568(170));
		_courseHotCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, HTSCREENWIDTH, itemSize.height) collectionViewLayout:flowLayout];
		[_courseHotCollectionView ht_updateSection:0 sectionMakerBlock:^(HTCollectionViewSectionMaker *sectionMaker) {
			[sectionMaker.cellClass([HTCourseHotCell class])
			 .itemSize(itemSize)
			 .itemVerticalSpacing(10) didSelectedCellBlock:^(UICollectionView *collectionView, NSInteger item, __kindof UICollectionViewCell *cell, __kindof HTCourseHotModel *model) {
//				NSString *identifier = [NSString stringWithFormat:@"%@%@", NSStringFromClass([HTCourseHotModel class]), model.result.contentid];
//				[HTRandomNumberManager ht_randomAppendWithIdentifier:identifier appendCount:1];
				model.joinTimes += 1;
				[cell setModel:model row:item];
				
                HTCourseOnlineVideoModel *onlineVideoModel = [HTCourseOnlineVideoModel mj_objectWithKeyValues:model.result.mj_keyValues];
				onlineVideoModel.views = [NSString stringWithFormat:@"%ld", model.joinTimes];
                HTCourseDetailController *detailController = [[HTCourseDetailController alloc] init];
                detailController.courseModel = onlineVideoModel;
                [self.ht_controller.navigationController pushViewController:detailController animated:true];
			}];
		}];
	}
	return _courseHotCollectionView;
}

@end
