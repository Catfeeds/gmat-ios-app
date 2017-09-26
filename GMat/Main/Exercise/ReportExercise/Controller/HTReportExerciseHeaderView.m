//
//  HTReportExerciseHeaderView.m
//  GMat
//
//  Created by hublot on 16/11/30.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTReportExerciseHeaderView.h"

@implementation HTReportExerciseHeaderView

+ (instancetype)headerViewTitle:(NSString *)headerViewTitle {
	HTReportExerciseHeaderView *headerView = [[HTReportExerciseHeaderView alloc] init];
	headerView.text = headerViewTitle;
	return headerView;
}

- (void)didMoveToSuperview {
	self.textAlignment = NSTextAlignmentCenter;
	self.font = [UIFont systemFontOfSize:18];
	self.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTheme];
}

@end
