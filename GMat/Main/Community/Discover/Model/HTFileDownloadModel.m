//
//  HTFileDownloadModel.m
//  GMat
//
//  Created by hublot on 2017/6/28.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTFileDownloadModel.h"

@interface HTFileDownloadModel ()

@end

@implementation HTFileDownloadModel

- (void)setSelected:(BOOL)selected {
	if (self.selectedObserver) {
		self.selectedObserver(selected);
	}
	_selected = selected;
	
	if (_selected) {
		[self.task resume];
	} else {
		[self.task suspend];
	}
}

@end
