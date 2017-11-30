//
//  HTDownloadSectionHeaderView.m
//  GMat
//
//  Created by hublot on 2017/6/28.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTDownloadSectionHeaderView.h"

@interface HTDownloadSectionHeaderView ()

@property (nonatomic, strong) UILabel *titleNameLabel;

@end

@implementation HTDownloadSectionHeaderView

- (void)didMoveToSuperview {
	[self addSubview:self.titleNameLabel];
	[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsMake(0, 20, 0, 20));
	}];
}

- (void)setModelArray:(NSArray *)modelArray section:(NSInteger)section {
	if (section == 0) {
		self.titleNameLabel.text = [NSString stringWithFormat:@"正在下载 (%ld)", modelArray.count];
	} else if (section == 1) {
		self.titleNameLabel.text = [NSString stringWithFormat:@"已下载 (%ld)", modelArray.count];
	}
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
		_titleNameLabel.font = [UIFont systemFontOfSize:13];
	}
	return _titleNameLabel;
}

@end
