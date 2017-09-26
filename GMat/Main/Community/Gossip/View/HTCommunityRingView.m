//
//  HTCommunityRingView.m
//  GMat
//
//  Created by hublot on 2016/11/23.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTCommunityRingView.h"

@interface HTCommunityRingView ()

@end

@implementation HTCommunityRingView

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor ht_colorStyle:HTColorStylePrimaryTheme];
	self.layer.cornerRadius = 5;
	self.layer.masksToBounds = true;
}

- (UIImageView *)ringImageView {
	if (!_ringImageView) {
		_ringImageView = [[UIImageView alloc] init];
		_ringImageView.image = [UIImage imageNamed:@"Community7"];
	}
	return _ringImageView;
}

- (UIView *)ringLineView {
	if (!_ringLineView) {
		_ringLineView = [[UIView alloc] init];
		_ringLineView.backgroundColor = [UIColor whiteColor];
		_ringLineView.ht_w = 1 / [UIScreen mainScreen].scale;
	}
	return _ringLineView;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.textColor = [UIColor whiteColor];
		_titleNameLabel.font = [UIFont ht_fontStyle:HTFontStyleDetailLarge];
	}
	return _titleNameLabel;
}


@end
