//
//  HTAppStoreStarCell.m
//  GMat
//
//  Created by hublot on 2017/8/4.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTAppStoreStarCell.h"
#import "HTAppStoreStarModel.h"

@interface HTAppStoreStarCell ()

@property (nonatomic, strong) UILabel *titleNameLabel;

@end

@implementation HTAppStoreStarCell

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor clearColor];
	UIView *backgroundSelectedView = [[UIView alloc] init];
	backgroundSelectedView.backgroundColor = [UIColor ht_colorStyle:HTColorStylePrimarySeparate];
	[self.selectedBackgroundView addSubview:backgroundSelectedView];
	[backgroundSelectedView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
	
	
	self.separatorInset = UIEdgeInsetsZero;
	[self addSubview:self.titleNameLabel];
	[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
}

- (void)setModel:(HTAppStoreStarModel *)model row:(NSInteger)row {
	self.titleNameLabel.textColor = model.titleColor;
	self.titleNameLabel.text = model.titleName;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.font = [UIFont systemFontOfSize:14];
		_titleNameLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _titleNameLabel;
}


@end
