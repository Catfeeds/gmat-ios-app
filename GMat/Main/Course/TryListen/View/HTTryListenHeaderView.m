//
//  HTTryListenHeaderView.m
//  GMat
//
//  Created by hublot on 16/10/13.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTTryListenHeaderView.h"
#import <UIButton+HTButtonCategory.h>

@interface HTTryListenHeaderView ()

@property (nonatomic, strong) UIButton *tryListenButton;

@end

@implementation HTTryListenHeaderView

- (void)didMoveToSuperview {
	[self addSubview:self.tryListenButton];
	[self.tryListenButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self).offset(15);
		make.bottom.mas_equalTo(self);
	}];
	[self layoutIfNeeded];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[self.tryListenButton ht_makeEdgeWithDirection:HTButtonEdgeDirectionHorizontal imageViewToTitleLabelSpeceOffset:5];
//	self.tryListenButton.w += 5;
}

- (UIButton *)tryListenButton {
	if (!_tryListenButton) {
		_tryListenButton = [[UIButton alloc] init];
		[_tryListenButton setTitleColor:[UIColor ht_colorStyle:HTColorStylePrimaryTitle] forState:UIControlStateNormal];
		_tryListenButton.titleLabel.font = [UIFont systemFontOfSize:14];
		[_tryListenButton setTitle:@"GMAT 试听课" forState:UIControlStateNormal];
		[_tryListenButton setImage:[[[UIImage ht_pureColor:[UIColor ht_colorStyle:HTColorStylePrimaryTheme]] ht_resetSize:CGSizeMake(4, 15)] ht_imageByRoundCornerRadius:2 corners:UIRectCornerAllCorners borderWidth:0 borderColor:nil borderLineJoin:kCGLineJoinRound] forState:UIControlStateNormal];
	}
	return _tryListenButton;
}


@end
