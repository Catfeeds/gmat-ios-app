//
//  THButton.m
//  TingApp
//
//  Created by hublot on 16/8/13.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "THButton.h"

@implementation THButton

- (void)willMoveToSuperview:(UIView *)newSuperview {
	self.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleHeadSmall];
	[self setTitleColor:[UIColor ht_colorStyle:HTColorStyleBackground] forState:UIControlStateNormal];
	[self setTitleColor:[UIColor ht_colorStyle:HTColorStyleBackground] forState:UIControlStateSelected];
	[self setBackgroundImage:[UIImage ht_pureColor:[UIColor ht_colorStyle:HTColorStylePrimaryTheme]] forState:UIControlStateNormal];
	[self setBackgroundImage:[UIImage ht_pureColor:[UIColor ht_colorString:@"ff8636"]] forState:UIControlStateHighlighted];
	[self setBackgroundImage:[UIImage ht_pureColor:[UIColor ht_colorStyle:HTColorStylePrimarySeparate]] forState:UIControlStateDisabled];
	self.layer.cornerRadius = 3;
	self.layer.masksToBounds = true;
	[super willMoveToSuperview:newSuperview];
}

@end
