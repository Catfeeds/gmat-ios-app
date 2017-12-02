//
//  HTIsPayAlertView.m
//  GMat
//
//  Created by Charles Cao on 2017/11/6.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTIsPayAlertView.h"

@implementation HTIsPayAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (IBAction)cancelAction:(id)sender {
	[self removeFromSuperview];
}
- (IBAction)confirm:(id)sender {
	self.confirmAction();
	[self removeFromSuperview];
}

@end
