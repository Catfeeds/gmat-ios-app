//
//  HTCourseOpenIndexCell.m
//  GMat
//
//  Created by hublot on 2017/4/19.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTCourseOpenIndexCell.h"
#import "HTCourseOpenModel.h"
#import "UICollectionView+HTSeparate.h"
#import "HTCourseOpenCell.h"
#import "HTCourseDetailController.h"
#import "THCourseTeacherDetailController.h"
#import "UICollectionViewCell+HTSeparate.h"
#import "HTRandomNumberManager.h"
#import <NSObject+HTTableRowHeight.h>

@interface HTCourseOpenIndexCell ()

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *model;

@end

@implementation HTCourseOpenIndexCell

- (void)didMoveToSuperview {
	[self addSubview:self.collectionView];
	[self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self).offset(10);
		make.bottom.mas_equalTo(self).offset(- 10);
		make.left.mas_equalTo(self);
		make.right.mas_equalTo(self);
	}];
}

- (void)setModel:(NSArray <HTCourseOpenModel *> *)model row:(NSInteger)row {
    if (model == _model) {
        return;
    }
    _model = model;
	NSArray *modelArray = model;
	[self.collectionView ht_updateSection:0 sectionMakerBlock:^(HTCollectionViewSectionMaker *sectionMaker) {
		sectionMaker.modelArray(modelArray);
	}];
    [model ht_setRowHeightNumber:@(140) forCellClass:self.class];
}

- (UICollectionView *)collectionView {
	if (!_collectionView) {
		UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
		flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		_collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
		_collectionView.showsHorizontalScrollIndicator = false;
		[_collectionView ht_updateSection:0 sectionMakerBlock:^(HTCollectionViewSectionMaker *sectionMaker) {
			[[sectionMaker.cellClass([HTCourseOpenCell class])
			  .itemSize(CGSizeMake((HTSCREENWIDTH + 50) / 2, 120))
			  .sectionInset(UIEdgeInsetsMake(0, 10, 0, 10))
			  .itemVerticalSpacing(10) didSelectedCellBlock:^(UICollectionView *collectionView, NSInteger item, __kindof UICollectionViewCell *cell, __kindof HTCourseOpenModel *model) {
				HTCourseDetailController *detailController = [[HTCourseDetailController alloc] init];
				HTCourseOnlineVideoModel *courseOnlineVideoModel = [[HTCourseOnlineVideoModel alloc] init];
				courseOnlineVideoModel.contentSmartApplythumb = model.image;
				courseOnlineVideoModel.contenttitle = model.name;
				courseOnlineVideoModel.contenttext = model.sentenceNumber;
				courseOnlineVideoModel.time = model.cnName;
				courseOnlineVideoModel.views = [NSString stringWithFormat:@"%ld", model.joinTimes];
				courseOnlineVideoModel.courseConnectTitle = @"立即报名";
				
				detailController.courseModel = courseOnlineVideoModel;
				[self.ht_controller.navigationController pushViewController:detailController animated:true];
			}] customCellBlock:^(UICollectionView *collectionView, NSInteger item, __kindof HTCourseOpenCell *cell, __kindof HTCourseOpenModel *model) {
				
				__weak HTCourseOpenCell *weakCell = cell;
                [cell.joinNowButton ht_whenTap:^(UIView *view) {
					THCourseTogetherTeacherModel *teacherModel = [[THCourseTogetherTeacherModel alloc] init];
					teacherModel.title = model.name;
                    [THCourseTeacherDetailController invideButtonTeapedWithModel:teacherModel complete:^{
						NSString *identifier = [NSString stringWithFormat:@"%@%@", NSStringFromClass(model.class), model.id];
						[HTRandomNumberManager ht_randomAppendWithIdentifier:identifier appendCount:1];
						model.joinTimes ++;
						[weakCell setModel:model row:item];
					}];
                }];
            }];
		}];
	}
	return _collectionView;
}

@end
