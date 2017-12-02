//
//  HTGuideView.m
//  GMat
//
//  Created by Charles Cao on 2017/12/1.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTGuideView.h"

@implementation HTGuideView

-(void)awakeFromNib{
	[super awakeFromNib];
	self.scrollView.delegate = self;
}

- (IBAction)removeAction:(id)sender {
	[self removeFromSuperview];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	NSInteger page = scrollView.contentOffset.x / HTSCREENWIDTH;
	self.pageControl.currentPage = page;
}

@end
