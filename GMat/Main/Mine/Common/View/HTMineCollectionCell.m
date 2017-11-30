//
//  HTMineCollectionCell.m
//  GMat
//
//  Created by hublot on 2016/10/19.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTMineCollectionCell.h"
#import "HTMineCollectionModel.h"
#import <UIButton+HTButtonCategory.h>

@interface HTMineCollectionCell ()

@property (nonatomic, strong) UIButton *titleNameButton;

@end

@implementation HTMineCollectionCell

- (void)didMoveToSuperview {
	[self addSubview:self.titleNameButton];
	[self.titleNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(self);
	}];
	self.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[self.titleNameButton ht_makeEdgeWithDirection:HTButtonEdgeDirectionHorizontal imageViewToTitleLabelSpeceOffset:HTADAPT568(10)];
}

- (void)setModel:(HTMineCollectionModel *)model row:(NSInteger)row {
	[self.titleNameButton setTitle:model.titleName forState:UIControlStateNormal];
	[self.titleNameButton setImage:[[UIImage imageNamed:model.imageName] ht_resetSizeZoomNumber:0.8] forState:UIControlStateNormal];
}

- (UIButton *)titleNameButton {
	if (!_titleNameButton) {
		_titleNameButton = [[UIButton alloc] init];
		[_titleNameButton setTitleColor:[UIColor ht_colorStyle:HTColorStylePrimaryTitle] forState:UIControlStateNormal];
		_titleNameButton.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleTitleSmall];
		_titleNameButton.userInteractionEnabled = false;
	}
	return _titleNameButton;
}


@end
