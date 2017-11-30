//
//  THTableButton.m
//  TingApp
//
//  Created by hublot on 16/8/24.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "THTableButton.h"

@implementation THTableButton

- (void)willMoveToSuperview:(UIView *)newSuperview {
	self.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleHeadSmall];
	[self setTitleColor:[UIColor ht_colorStyle:HTColorStyleBackground] forState:UIControlStateNormal];
	[self setTitleColor:[UIColor ht_colorStyle:HTColorStyleBackground] forState:UIControlStateSelected];
	[self setBackgroundImage:[UIImage ht_pureColor:[UIColor ht_colorStyle:HTColorStylePrimaryTheme]] forState:UIControlStateNormal];
	[self setBackgroundImage:[UIImage ht_pureColor:[UIColor ht_colorString:@"5f88c1"]] forState:UIControlStateHighlighted];
	[super willMoveToSuperview:newSuperview];
}

@end
