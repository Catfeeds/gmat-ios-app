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
@property (nonatomic, strong) UIButton *continueButton;

@end

@implementation HTExerciseCollectionCell

- (void)didMoveToSuperview {
	[self addSubview:self.titleNameButton];
	[self addSubview:self.continueButton];
	self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.15];
	[self.titleNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.mas_equalTo(self);
	}];
	[self.continueButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.mas_top);
		make.right.mas_equalTo(self.mas_right);
		make.height.mas_equalTo(18);
		make.width.mas_equalTo(34);
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
	self.continueButton.hidden = !model.isShowContinue;
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

- (UIButton *)continueButton{
	if (!_continueButton) {
		_continueButton = [[UIButton alloc]init];
		[_continueButton setBackgroundImage:[UIImage imageNamed:@"continue"] forState:UIControlStateNormal];
		_continueButton.enabled = NO;
		UIEdgeInsets edg = _continueButton.titleEdgeInsets;
		edg.top -= 4;
		[_continueButton setTitleEdgeInsets:edg];
		[_continueButton setTitle:@"继续" forState:UIControlStateNormal];
		_continueButton.titleLabel.font = [UIFont systemFontOfSize:12];
	}
	return _continueButton;
}

- (void)setFrame:(CGRect)frame {
	self.layer.cornerRadius = 3;
	self.layer.masksToBounds = true;
	[super setFrame:frame];
}

@end
