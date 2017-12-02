//
//  HTQuestionMoreMenuCell.m
//  GMat
//
//  Created by hublot on 2017/8/23.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTQuestionMoreMenuCell.h"
#import "HTQuestionMoreMenuModel.h"

@interface HTQuestionMoreMenuCell ()

@property (nonatomic, strong) UILabel *titleNameLabel;

@end

@implementation HTQuestionMoreMenuCell

- (void)didMoveToSuperview {
	UIView *selectedBackgroundView = [[UIView alloc] init];
	selectedBackgroundView.backgroundColor = [UIColor ht_colorString:@"f3f3f3"];
	self.selectedBackgroundView = selectedBackgroundView;
	
	[self addSubview:self.titleNameLabel];
	[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
}

- (void)setModel:(HTQuestionMoreMenuModel *)model row:(NSInteger)row {
	if (!model.isSelected) {
		self.titleNameLabel.text = model.titleName;
	} else {
		self.titleNameLabel.text = model.selectedTitle;
	}
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.font = [UIFont systemFontOfSize:15];
		_titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_titleNameLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _titleNameLabel;
}


@end
