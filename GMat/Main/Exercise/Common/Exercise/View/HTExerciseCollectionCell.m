//
//  HTExerciseCollectionCell.m
//  GMat
//
//  Created by hublot on 2016/10/18.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTExerciseCollectionCell.h"
#import "HTExerciseCollectionModel.h"
#import <UIButton+HTButtonCategory.h>

@interface HTExerciseCollectionCell ()

@property (nonatomic, strong) UIButton *titleNameButton;

@end

@implementation HTExerciseCollectionCell

- (void)didMoveToSuperview {
	[self addSubview:self.titleNameButton];
	self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.15];
	[self.titleNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.mas_equalTo(self);
	}];
	self.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.15];
}

- (void)setModel:(HTExerciseCollectionModel *)model row:(NSInteger)row {
	[self.titleNameButton setTitle:model.titleName forState:UIControlStateNormal];
	UIImage *image = [UIImage imageNamed:model.imageName];
	CGFloat maxImageHeight = 25;
	CGFloat maxImageWidth = 25;
	CGFloat imageHeightZoomNumber = maxImageHeight / image.size.height;
	CGFloat imageWidthZoomNumber = maxImageWidth / image.size.width;
	CGFloat imageZoomNumber = MIN(imageHeightZoomNumber, imageWidthZoomNumber);
	[self.titleNameButton setImage:[image ht_resetSizeZoomNumber:imageZoomNumber] forState:UIControlStateNormal];
	[self.titleNameButton ht_makeEdgeWithDirection:HTButtonEdgeDirectionVertical imageViewToTitleLabelSpeceOffset:10];
}

- (UIButton *)titleNameButton {
	if (!_titleNameButton) {
		_titleNameButton = [[UIButton alloc] init];
		[_titleNameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		_titleNameButton.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleDetailLarge];
		_titleNameButton.userInteractionEnabled = false;
	}
	return _titleNameButton;
}

- (void)setFrame:(CGRect)frame {
	self.layer.cornerRadius = 3;
	self.layer.masksToBounds = true;
	[super setFrame:frame];
}

@end
