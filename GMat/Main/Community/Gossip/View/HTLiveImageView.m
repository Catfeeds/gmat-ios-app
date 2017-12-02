//
//  HTLiveImageView.m
//  GMat
//
//  Created by Charles Cao on 2017/11/6.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTLiveImageView.h"

@implementation HTLiveImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
	[super awakeFromNib];
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage)];
	[self.imageView addGestureRecognizer:tap];

}

- (void)tapImage
{
	self.tap();
}


@end
