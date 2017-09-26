//
//  HTReportExcelCollectionCell.m
//  GMat
//
//  Created by hublot on 16/11/30.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTReportExcelCollectionCell.h"
#import "UICollectionView+HTSeparate.h"
#import "HTReportModel.h"
#import <NSObject+HTTableRowHeight.h>

@interface HTReportExcelCollectionCell ()

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HTReportExcelCollectionCell

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor clearColor];
	[self addSubview:self.collectionView];
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 15, 0, 15));
    }];
}

- (void)setModel:(HTReportModel *)model row:(NSInteger)row {
	NSArray *modelArray;
	NSInteger colCount = self.collectionExcelType == collectionExcelTypeThreeColFourRow ? 3 : 5;
	if (self.collectionExcelType == collectionExcelTypeThreeColFourRow) {
		NSString *(^createMinuteBlock)(NSInteger second) = ^(NSInteger second) {
			if (second <= 60) {
				return [NSString stringWithFormat:@"%lds", second];
			} else {
				return [NSString stringWithFormat:@"%ldm%lds", second / 60, second % 60];
			}
		};
		modelArray = @[@"", @"正确率", @"Pace", @"SC", [NSString stringWithFormat:@"%ld%%", model.sc_data.correctAll], createMinuteBlock(model.sc_data.averageTime), @"RC", [NSString stringWithFormat:@"%ld%%", model.rc_data.correctAll], createMinuteBlock(model.rc_data.averageTime), @"CR", [NSString stringWithFormat:@"%ld%%", model.cr_data.correctAll], createMinuteBlock(model.cr_data.averageTime)];
	} else {
		modelArray = @[@"", @"600以下", @"600-650", @"650-700", @"750以上", @"SC", [NSString stringWithFormat:@"%ld%%", model.sc_diffculty600.correctAll], [NSString stringWithFormat:@"%ld%%", model.sc_diffculty650.correctAll], [NSString stringWithFormat:@"%ld%%", model.sc_diffculty700.correctAll], [NSString stringWithFormat:@"%ld%%", model.sc_diffculty750.correctAll], @"RC", [NSString stringWithFormat:@"%ld%%", model.rc_diffculty600.correctAll], [NSString stringWithFormat:@"%ld%%", model.rc_diffculty650.correctAll], [NSString stringWithFormat:@"%ld%%", model.rc_diffculty700.correctAll], [NSString stringWithFormat:@"%ld%%", model.rc_diffculty750.correctAll], @"CR", [NSString stringWithFormat:@"%ld%%", model.cr_diffculty600.correctAll], [NSString stringWithFormat:@"%ld%%", model.cr_diffculty650.correctAll], [NSString stringWithFormat:@"%ld%%", model.cr_diffculty700.correctAll], [NSString stringWithFormat:@"%ld%%", model.cr_diffculty750.correctAll]];
	}
	[self.collectionView ht_updateSection:0 sectionMakerBlock:^(HTCollectionViewSectionMaker *sectionMaker) {
		[sectionMaker.modelArray(modelArray)
		 .itemSize(CGSizeMake((HTSCREENWIDTH - 30 - colCount - 1) / colCount, (200 - 3) / 4.0))
		 .itemHorizontalSpacing(1)
		 .itemVerticalSpacing(1) customCellBlock:^(UICollectionView *collectionView, NSInteger item, __kindof UICollectionViewCell *cell, __kindof NSObject *model) {
			UILabel *titleNameLabel = [[UILabel alloc] init];
			titleNameLabel.font = [UIFont systemFontOfSize:15];
			titleNameLabel.numberOfLines = 0;
			titleNameLabel.textAlignment = NSTextAlignmentCenter;
			titleNameLabel.tag = 101;
			[[cell viewWithTag:101] removeFromSuperview];
			[cell addSubview:titleNameLabel];
			cell.backgroundColor = [UIColor whiteColor];
			[titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
				make.edges.mas_equalTo(cell);
			}];
			if (item % colCount == 0) {
				titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTheme];
			} else {
				titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
			}
			titleNameLabel.text = model;
		}];
	}];
	self.collectionView.backgroundColor = [UIColor clearColor];
    CGFloat modelHeight = 50 * 4;
    [model ht_setRowHeightNumber:@(modelHeight) forCellClass:self.class];
}

- (UICollectionView *)collectionView {
	if (!_collectionView) {
		UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
		_collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
		_collectionView.scrollEnabled = false;
	}
	return _collectionView;
}


@end
 
