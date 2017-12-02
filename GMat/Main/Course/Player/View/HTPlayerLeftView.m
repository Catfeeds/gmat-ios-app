//
//  HTPlayerLeftView.m
//  GMat
//
//  Created by hublot on 2017/9/28.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTPlayerLeftView.h"

@interface HTPlayerLeftView ()

@end

@implementation HTPlayerLeftView

- (void)dealloc {
	
}

- (void)didMoveToSuperview {
	[self addSubview:self.lockPlayerButton];
	[self.lockPlayerButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.center.mas_equalTo(self);
		make.width.height.mas_equalTo(50);
	}];
}

- (UIButton *)lockPlayerButton {
	if (!_lockPlayerButton) {
		_lockPlayerButton = [[UIButton alloc] init];
		CGFloat imageScale = 0.15;
		UIImage *normalImage = [UIImage imageNamed:@"cn_player_notLocked"];
		normalImage = [normalImage ht_resetSizeZoomNumber:imageScale];
		UIImage *selectedImage = [UIImage imageNamed:@"cn_player_isLocked"];
		selectedImage =[selectedImage ht_resetSizeZoomNumber:imageScale];
		[_lockPlayerButton setImage:normalImage forState:UIControlStateNormal];
		[_lockPlayerButton setImage:normalImage forState:UIControlStateNormal | UIControlStateHighlighted];
		[_lockPlayerButton setImage:selectedImage forState:UIControlStateSelected];
		[_lockPlayerButton setImage:selectedImage forState:UIControlStateSelected | UIControlStateHighlighted];
		
		_lockPlayerButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
		_lockPlayerButton.layer.cornerRadius = 4;
		_lockPlayerButton.layer.masksToBounds = true;
	}
	return _lockPlayerButton;
}

@end
