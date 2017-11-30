//
//  HTNavigationBar.m
//  GMat
//
//  Created by hublot on 2016/10/20.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTNavigationBar.h"

@implementation HTNavigationBar

- (nullable UIView *)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event {
	UIView *superHitTestView = [super hitTest:point withEvent:event];
	if (self.canCancelTouchesInCell && superHitTestView == self) {
		return nil;
	}
 	return superHitTestView;
}

@end
