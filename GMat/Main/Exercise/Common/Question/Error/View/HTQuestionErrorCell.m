//
//  HTQuestionErrorCell.m
//  GMat
//
//  Created by hublot on 2017/8/23.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTQuestionErrorCell.h"
#import "HTQuestionErrorModel.h"

@interface HTQuestionErrorCell ()

@property (nonatomic, strong) UILabel *titleNameLabel;

@end

@implementation HTQuestionErrorCell

- (void)didMoveToSuperview {
	UIView *selectedBackgroundView = [[UIView alloc] init];
	UIColor *separtorColor = [UIColor ht_colorString:@"f3f3f3"];
	selectedBackgroundView.backgroundColor = separtorColor;
	self.selectedBackgroundView = selectedBackgroundView;
	[self addSubview:self.titleNameLabel];
	[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsMake(0, 15, 0, 15));
	}];
}

- (void)setModel:(HTQuestionErrorModel *)model row:(NSInteger)row {
	self.titleNameLabel.text = model.titleName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	self.accessoryType = selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_titleNameLabel.font = [UIFont systemFontOfSize:15];
	}
	return _titleNameLabel;
}



@end
