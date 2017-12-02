//
//  HTDiscoverItemCell.m
//  GMat
//
//  Created by hublot on 2017/7/4.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTDiscoverItemCell.h"
#import "HTDiscoverItemModel.h"
#import <UIButton+HTButtonCategory.h>

@interface HTDiscoverItemCell ()

@property (nonatomic, strong) UIButton *titleNameButton;

@end

@implementation HTDiscoverItemCell

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor clearColor];
	self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
	[self addSubview:self.titleNameButton];
	[self.titleNameButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.center.mas_equalTo(self);
	}];
}

- (void)setModel:(HTDiscoverItemModel *)model row:(NSInteger)row {
	[self.titleNameButton setTitle:model.titleName forState:UIControlStateNormal];
	UIImage *image = [UIImage imageNamed:model.imageName];
	image = [image ht_resetSizeZoomNumber:0.5];
	[self.titleNameButton setImage:image forState:UIControlStateNormal];
	[self.titleNameButton ht_makeEdgeWithDirection:HTButtonEdgeDirectionVertical imageViewToTitleLabelSpeceOffset:5];
}

- (void)setHighlighted:(BOOL)highlighted {
	[super setHighlighted:highlighted];
	self.titleNameButton.highlighted = highlighted;
}

- (UIButton *)titleNameButton {
	if (!_titleNameButton) {
		_titleNameButton = [[UIButton alloc] init];
		[_titleNameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		_titleNameButton.titleLabel.font = [UIFont systemFontOfSize:12];
		_titleNameButton.userInteractionEnabled = false;
	}
	return _titleNameButton;
}

@end
