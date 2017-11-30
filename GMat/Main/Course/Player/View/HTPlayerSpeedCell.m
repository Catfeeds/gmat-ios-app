//
//  HTPlayerSpeedCell.m
//  GMat
//
//  Created by hublot on 2017/9/28.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTPlayerSpeedCell.h"
#import "HTPlayerSpeedModel.h"

@interface HTPlayerSpeedCell ()

@property (nonatomic, strong) UIButton *titleNameButton;

@end

@implementation HTPlayerSpeedCell

- (void)dealloc {
	
}

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor clearColor];
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	[self addSubview:self.titleNameButton];
	[self.titleNameButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsMake(4, 50, 4, 50));
	}];
}

- (void)setModel:(HTPlayerSpeedModel *)model row:(NSInteger)row {
	[self.titleNameButton setTitle:model.titleName forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	if (selected) {
		self.titleNameButton.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
	} else {
		self.titleNameButton.layer.borderWidth = 0;
	}
}

- (UIButton *)titleNameButton {
	if (!_titleNameButton) {
		_titleNameButton = [[UIButton alloc] init];
		_titleNameButton.titleLabel.font = [UIFont systemFontOfSize:15];
		[_titleNameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		_titleNameButton.layer.borderColor = [UIColor whiteColor].CGColor;
		_titleNameButton.layer.cornerRadius = 3;
		_titleNameButton.layer.masksToBounds = true;
		_titleNameButton.userInteractionEnabled = false;
	}
	return _titleNameButton;
}

@end
