//
//  HTStoryHeaderView.m
//  GMat
//
//  Created by hublot on 17/8/29.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTStoryHeaderView.h"

@interface HTStoryHeaderView ()

@property (nonatomic, strong) UIButton *backgroundButton;

@end

@implementation HTStoryHeaderView

- (void)didMoveToSuperview {
    [self addSubview:self.backgroundButton];
    [self.backgroundButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (UIButton *)backgroundButton {
	if (!_backgroundButton) {
		_backgroundButton = [[UIButton alloc] init];
		UIImage *image = [UIImage imageNamed:@"cn_story_header"];
		UIImage *darkImage = [UIImage ht_pureColor:[UIColor colorWithWhite:0 alpha:0.5]];
		darkImage = [darkImage ht_resetSize:image.size];
		UIImage *normalImage = image;
		UIImage *highlightImage = [image ht_appendImage:darkImage atRect:CGRectMake(0, 0, darkImage.size.width, darkImage.size.height)];
		[_backgroundButton setImage:normalImage forState:UIControlStateNormal];
		[_backgroundButton setImage:highlightImage forState:UIControlStateHighlighted];
	}
	return _backgroundButton;
}

@end
