//
//  HTStoryDetailHeaderView.m
//  GMat
//
//  Created by hublot on 17/8/31.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTStoryDetailHeaderView.h"
#import <UICollectionView+HTSeparate.h>
#import "HTStoryDetailHeaderCell.h"
#import <NSString+HTString.h>

@interface HTStoryDetailHeaderView ()

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@property (nonatomic, strong) UIView *shadowView;

@end

@implementation HTStoryDetailHeaderView

- (void)didMoveToSuperview {
    [self addSubview:self.titleNameLabel];
    [self addSubview:self.shadowView];
    [self addSubview:self.collectionView];
    [self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(- 15);
    }];
    [self.shadowView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.collectionView);
    }];
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(- 15);
        make.top.mas_equalTo(self.titleNameLabel.mas_bottom).offset(15);
        make.bottom.mas_equalTo(- 15);
    }];
}

- (void)setModel:(HTStoryModel *)model {
    self.titleNameLabel.text = model.contenttitle;
    CGFloat titleTextHeight = [self.titleNameLabel.text ht_stringHeightWithWidth:HTSCREENWIDTH - 30 font:self.titleNameLabel.font textView:nil];
    CGFloat modelHeight = 15;
    modelHeight += titleTextHeight;
    modelHeight += 15;
    NSArray *modelArray = @[
                              [NSString stringWithFormat:@"姓名: %@", model.fullName],
                              [NSString stringWithFormat:@"基础: %@", model.basics],
                              [NSString stringWithFormat:@"出分时间: %@", model.outTime],
                              [NSString stringWithFormat:@"班型: %@", model.classType],
                              [NSString stringWithFormat:@"考试次数: %@", model.exa],
                              [NSString stringWithFormat:@"分数: %@", model.fraction],
                          ];
    [self.collectionView ht_updateSection:0 sectionMakerBlock:^(HTCollectionViewSectionMaker *sectionMaker) {
        sectionMaker.modelArray(modelArray);
    }];
    CGFloat colCount = 2;
    CGFloat rowHeight = 25;
    CGFloat collectionHeight = ceil(modelArray.count / colCount) * rowHeight + 15 + 15;
    modelHeight += collectionHeight;
    modelHeight += 15;
    self.ht_h = modelHeight;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:self.shadowView.bounds];
    self.shadowView.layer.shadowPath = bezierPath.CGPath;
}

- (UILabel *)titleNameLabel {
    if (!_titleNameLabel) {
        _titleNameLabel = [[UILabel alloc] init];
        _titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
        _titleNameLabel.font = [UIFont systemFontOfSize:20 weight:0.1];
        _titleNameLabel.numberOfLines = 0;
    }
    return _titleNameLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.scrollEnabled = false;
        _collectionView.showsVerticalScrollIndicator = false;
        CGFloat itemHorizontalSpacing = 10;
        CGFloat itemVerticalSpacing = 0;
        UIEdgeInsets sectionEdge = UIEdgeInsetsMake(15, 15, 15, 15);
        NSInteger colCount = 2;
        CGFloat itemWidth = (HTSCREENWIDTH - 30 - sectionEdge.left - sectionEdge.right - (colCount - 1) * itemHorizontalSpacing) / colCount;
        CGFloat itemHeight = 25;
        CGSize itemSize = CGSizeMake(itemWidth, itemHeight);
        [_collectionView ht_updateSection:0 sectionMakerBlock:^(HTCollectionViewSectionMaker *sectionMaker) {
            [sectionMaker.cellClass([HTStoryDetailHeaderCell class]).itemSize(itemSize).sectionInset(sectionEdge).itemHorizontalSpacing(itemHorizontalSpacing).itemVerticalSpacing(itemVerticalSpacing) didSelectedCellBlock:^(UICollectionView *collectionView, NSInteger item, __kindof UICollectionViewCell *cell, __kindof NSObject *model) {
                
            }];
        }];
        UIView *backgroundView = [[UIView alloc] init];
        
        __weak typeof(self) weakSelf = self;
        [backgroundView bk_addObserverForKeyPath:NSStringFromSelector(@selector(frame)) options:NSKeyValueObservingOptionInitial task:^(id obj, NSDictionary *change) {
            weakSelf.gradientLayer.frame = weakSelf.collectionView.backgroundView.bounds;
        }];
        [backgroundView.layer addSublayer:self.gradientLayer];
        _collectionView.backgroundView = backgroundView;
    }
    return _collectionView;
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.colors = @[
                                     (id)[UIColor ht_colorString:@"215b90"].CGColor,
                                     (id)[UIColor ht_colorString:@"548fc1"].CGColor,
                                 ];
        _gradientLayer.locations = @[@(0), @(1)];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(1, 1);
    }
    return _gradientLayer;
}


- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = [UIColor whiteColor];
        _shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
        _shadowView.layer.shadowOffset = CGSizeMake(2, 2);
        _shadowView.layer.shadowOpacity = 0.3;
        _shadowView.layer.shadowRadius = 3;
    }
    return _shadowView;
}

@end
