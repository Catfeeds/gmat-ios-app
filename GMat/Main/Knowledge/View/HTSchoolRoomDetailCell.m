//
//  HTSchoolRoomDetailCell.m
//  GMat
//
//  Created by Charles Cao on 2017/11/20.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTSchoolRoomDetailCell.h"

@implementation HTSchoolRoomDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContainer:(NSTextContainer *)container{
	if (self.container) {
		if (_container != container) {
			for (UIView *view in self.content.subviews) {
				if ([view isKindOfClass:[UITextView class]]) {
					[view removeFromSuperview];
				}
			}
			UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width-30, self.frame.size.height - 30) textContainer:container];
			[self.content addSubview:textView];
		}
	}else{
		UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width-30, self.frame.size.height - 30) textContainer:container];
		[self.content addSubview:textView];
	}
	_container = container;
	
}

@end
