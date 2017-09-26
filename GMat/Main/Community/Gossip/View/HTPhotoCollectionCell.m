//
//  HTPhotoCollectionCell.m
//  GMat
//
//  Created by hublot on 2016/11/21.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTPhotoCollectionCell.h"

@interface HTPhotoCollectionCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation HTPhotoCollectionCell

- (void)didMoveToSuperview {
	[self.contentView addSubview:self.imageView];
	[self.contentView addSubview:self.deleteButton];
	[self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(self);
	}];
	[self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.right.mas_equalTo(self);
	}];
}

- (void)setModel:(UIImage *)model row:(NSInteger)row {
	self.imageView.image = model;
}

- (UIImageView *)imageView {
	if (!_imageView) {
		_imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = true;
	}
	return _imageView;
}

- (UIButton *)deleteButton {
	if (!_deleteButton) {
		_deleteButton = [[UIButton alloc] init];
		[_deleteButton setImage:[[UIImage imageNamed:@"Community5"] ht_resetSize:CGSizeMake(HTADAPT568(15), HTADAPT568(15))] forState:UIControlStateNormal];
	}
	return _deleteButton;
}


@end
