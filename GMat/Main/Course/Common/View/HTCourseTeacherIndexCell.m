//
//  HTCourseTeacherIndexCell.m
//  GMat
//
//  Created by hublot on 2017/4/19.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTCourseTeacherIndexCell.h"
#import "HTCourseTeacherCell.h"
#import "THCourseTogetherTeacherModel.h"
#import "THCourseTeacherDetailController.h"
#import "HTRandomNumberManager.h"
#import <UICollectionView+HTSeparate.h>
#import <UICollectionViewCell+HTSeparate.h>
#import <NSObject+HTTableRowHeight.h>

@interface HTCourseTeacherIndexCell ()

@property (nonatomic, strong) UICollectionView *teacherCollectionView;

@property (nonatomic, strong) NSArray *model;

@end

@implementation HTCourseTeacherIndexCell

- (void)didMoveToSuperview {
	[self addSubview:self.teacherCollectionView];
}

- (void)setModel:(NSArray <THCourseTogetherTeacherModel *> *)model row:(NSInteger)row {
    if (model == _model) {
        return;
    }
    _model = model;
	NSArray <THCourseTogetherTeacherModel *> *modelArray = model;
	[self.teacherCollectionView ht_updateSection:0 sectionMakerBlock:^(HTCollectionViewSectionMaker *sectionMaker) {
		sectionMaker.modelArray(modelArray);
	}];
	self.teacherCollectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [model ht_setRowHeightNumber:@(150) forCellClass:self.class];
}

- (UICollectionView *)teacherCollectionView {
	if (!_teacherCollectionView) {
		UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
		flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		_teacherCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, HTSCREENWIDTH, 150) collectionViewLayout:flowLayout];
		[_teacherCollectionView ht_updateSection:0 sectionMakerBlock:^(HTCollectionViewSectionMaker *sectionMaker) {
			[[sectionMaker.cellClass([HTCourseTeacherCell class])
			  .itemSize(CGSizeMake(HTSCREENWIDTH, 150))
			  .itemVerticalSpacing(10) didSelectedCellBlock:^(UICollectionView *collectionView, NSInteger item, __kindof HTCourseTeacherCell *cell, __kindof THCourseTogetherTeacherModel *model) {
				THCourseTeacherDetailController *teacherDetailController = [[THCourseTeacherDetailController alloc] init];
				teacherDetailController.model = model;
				[self.ht_controller.navigationController pushViewController:teacherDetailController animated:true];
			}] customCellBlock:^(UICollectionView *collectionView, NSInteger item, __kindof HTCourseTeacherCell *cell, __kindof THCourseTogetherTeacherModel *model) {
				__weak HTCourseTeacherCell *weakCell = cell;
				[cell.joinTogetherButton ht_whenTap:^(UIView *view) {
					[THCourseTeacherDetailController invideButtonTeapedWithModel:model complete:^{
						NSString *identifier = [NSString stringWithFormat:@"%@%@", NSStringFromClass(self.class), model.teacherId];
						[HTRandomNumberManager ht_randomAppendWithIdentifier:identifier appendCount:1];
						model.joinTimes ++;
						[weakCell setModel:model row:item];
					}];
				}];
			}];
		}];
	}
	return _teacherCollectionView;
}

@end
