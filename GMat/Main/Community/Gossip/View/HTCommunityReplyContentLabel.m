//
//  HTCommunityReplyContentCell.m
//  GMat
//
//  Created by hublot on 2016/12/5.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTCommunityReplyContentLabel.h"

@interface HTCommunityReplyContentLabel ()

@end

@implementation HTCommunityReplyContentLabel

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.displaysAsynchronously = YES;
		self.ignoreCommonProperties = YES;
		self.fadeOnHighlight = NO;
		self.fadeOnAsynchronouslyDisplay = NO;
	}
	return self;
}

- (void)setModel:(HTCommunityReplyLayoutModel *)model {
	_model = model;
	self.textLayout = model.titleNameLayout;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.backgroundColor = [[UIColor groupTableViewBackgroundColor] colorWithAlphaComponent:1];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.backgroundColor = [[UIColor groupTableViewBackgroundColor] colorWithAlphaComponent:1];
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0];
    }];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

@end
