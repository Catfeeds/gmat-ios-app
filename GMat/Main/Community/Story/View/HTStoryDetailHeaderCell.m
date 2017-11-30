//
//  HTStoryDetailHeaderCell.m
//  GMat
//
//  Created by hublot on 17/8/31.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTStoryDetailHeaderCell.h"

@interface HTStoryDetailHeaderCell ()

@property (nonatomic, strong) UILabel *titleNameLabel;

@end

@implementation HTStoryDetailHeaderCell

- (void)didMoveToSuperview {
    self.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage ht_pureColor:[UIColor clearColor]]];
    
    [self addSubview:self.titleNameLabel];
    [self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)setModel:(NSString *)model row:(NSInteger)row {
    self.titleNameLabel.text = model;
}

- (UILabel *)titleNameLabel {
    if (!_titleNameLabel) {
        _titleNameLabel = [[UILabel alloc] init];
        _titleNameLabel.textColor = [UIColor whiteColor];
        _titleNameLabel.font = [UIFont systemFontOfSize:13];
    }
    return _titleNameLabel;
}


@end
