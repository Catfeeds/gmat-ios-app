//
//  HTKnowledgeCategoryCell.m
//  GMat
//
//  Created by hublot on 16/10/12.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTKnowledgeCategoryCell.h"
#import "HTKnowledgeModel.h"

@interface HTKnowledgeCategoryCell ()

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UIButton *rightDetailButton;

@end

@implementation HTKnowledgeCategoryCell

- (void)didMoveToSuperview {
	[self addSubview:self.titleNameLabel];
	[self addSubview:self.rightDetailButton];
	[self.titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self).offset(15);
		make.top.bottom.mas_equalTo(self);
		make.right.mas_equalTo(self.rightDetailButton.mas_left);
	}];
	[self.rightDetailButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.mas_right).offset(- 40);
		make.centerY.mas_equalTo(self);
	}];
}

- (void)setModel:(KnowledgeCategorytype *)model row:(NSInteger)row {
	self.titleNameLabel.text = model.catname;
	self.backgroundColor = [model.cellBackgroundColor colorWithAlphaComponent:1 - 0.2 * row];
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_titleNameLabel.font = [UIFont systemFontOfSize:15];
	}
	return _titleNameLabel;
}

- (UIButton *)rightDetailButton {
	if (!_rightDetailButton) {
		_rightDetailButton = [[UIButton alloc] init];
		[_rightDetailButton setImage:[[UIImage imageNamed:@"Knowledge6"] ht_resetSizeZoomNumber:0.7] forState:UIControlStateNormal];
	}
	return _rightDetailButton;
}

- (void)setFrame:(CGRect)frame {
	frame.origin.x += 15;
	frame.size.width -= 30;
	[super setFrame:frame];
}

@end
