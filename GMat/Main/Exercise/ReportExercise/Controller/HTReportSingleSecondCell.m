//
//  HTReportSingleSecondCell.m
//  GMat
//
//  Created by hublot on 16/11/30.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTReportSingleSecondCell.h"
#import "UICollectionView+HTSeparate.h"
#import "HTReportModel.h"
#import "NSString+HTString.h"

@interface HTReportSingleSecondCell ()

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HTReportSingleSecondCell

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor clearColor];
	[self addSubview:self.collectionView];
	[self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsMake(0, 15, 0, 15));
	}];
}

- (void)setModel:(HTReportModel *)model row:(NSInteger)row {
	NSArray *firstArray = @[model.whole_diffculty600, model.whole_diffculty650, model.whole_diffculty700, model.whole_diffculty750];
	NSArray *secondArray = @[model.sc_diffculty600, model.sc_diffculty650, model.sc_diffculty700, model.sc_diffculty750];
	NSArray *thridArray = @[model.rc_diffculty600, model.rc_diffculty650, model.rc_diffculty700, model.rc_diffculty750];
	NSArray *fourthArray = @[model.cr_diffculty600, model.cr_diffculty650, model.cr_diffculty700, model.cr_diffculty750];
	NSArray *fifthArray = @[model.quant_diffculty600, model.quant_diffculty650, model.quant_diffculty700, model.quant_diffculty750];
	NSArray *collectionModelArray = (@[firstArray, secondArray, thridArray, fourthArray, fifthArray])[self.reportStyle];
	NSArray *scoreModelArray = @[@"难度600以下题目", @"难度600-650题目", @"难度650-700题目", @"难度700以上题目"];
	NSMutableArray *attributedArray = [@[] mutableCopy];
	[collectionModelArray enumerateObjectsUsingBlock:^(Whole_Diffculty600 *obj, NSUInteger idx, BOOL * _Nonnull stop) {
		NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld%%\n%@", obj.correctAll, scoreModelArray[idx]] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:14]}];
		[attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} range:NSMakeRange(0, [NSString stringWithFormat:@"%ld", obj.correctAll].length + 1)];
		[attributedArray addObject:attributedString];
	}];
	[self.collectionView ht_updateSection:0 sectionMakerBlock:^(HTCollectionViewSectionMaker *sectionMaker) {
		sectionMaker.itemSize(CGSizeMake(((HTSCREENWIDTH - 30) - 2) / 2, (160 - 2) / 2)).modelArray(attributedArray);
	}];
}

- (UICollectionView *)collectionView {
	if (!_collectionView) {
		UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
		_collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [_collectionView ht_updateSection:0 sectionMakerBlock:^(HTCollectionViewSectionMaker *sectionMaker) {
            [sectionMaker
			 .itemHorizontalSpacing(2)
			 .itemVerticalSpacing(2) customCellBlock:^(UICollectionView *collectionView, NSInteger item, __kindof UICollectionViewCell *cell, __kindof NSObject *model) {
                cell.backgroundColor = [UIColor ht_colorString:@"65a8ee"];
                UILabel *titleNameLabel = [[UILabel alloc] init];
                titleNameLabel.numberOfLines = 0;
                titleNameLabel.textAlignment = NSTextAlignmentCenter;
                titleNameLabel.attributedText = model;
                titleNameLabel.tag = 101;
                [[cell viewWithTag:101] removeFromSuperview];
                [cell addSubview:titleNameLabel];
                [titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(cell);
                }];
            }];
        }];
		_collectionView.backgroundColor = [UIColor clearColor];
		_collectionView.scrollEnabled = false;
		_collectionView.allowsSelection = false;
	}
	return _collectionView;
}


@end
