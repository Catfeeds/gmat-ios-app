//
//  THMinePreferenceInputCell.m
//  TingApp
//
//  Created by hublot on 16/9/1.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "THMinePreferenceInputCell.h"

@implementation THMinePreferenceInputCell

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor clearColor];
}

- (void)setFrame:(CGRect)frame {
	frame.origin.x += 40;
	frame.origin.y += 20;
	frame.size.width -= 80;
	frame.size.height -= 20;
	[super setFrame:frame];
}

@end
