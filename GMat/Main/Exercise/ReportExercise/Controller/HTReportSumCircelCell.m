//
//  HTReportSumCircelCell.m
//  GMat
//
//  Created by hublot on 16/11/30.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTReportSumCircelCell.h"
#import "HTReportExerciseCircleView.h"
#import "HTReportModel.h"
#import <NSObject+HTTableRowHeight.h>

@interface HTReportSumCircelCell ()

@property (nonatomic, strong) HTReportExerciseCircleView *rightPercentView;

@property (nonatomic, strong) HTReportExerciseCircleView *exerciseTimeView;

@end

@implementation HTReportSumCircelCell

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor clearColor];
	[self addSubview:self.rightPercentView];
	[self addSubview:self.exerciseTimeView];
}

- (void)setModel:(HTReportModel *)model row:(NSInteger)row {
	CGFloat circelViewHeight = 170;
	self.rightPercentView.bottomDetailName = [NSString stringWithFormat:@"正确率:(%ld%%)", model.quant_data.correctAll];
	self.rightPercentView.progress = model.quant_data.correctAll / 100.0;
	self.exerciseTimeView.bottomDetailName = [NSString stringWithFormat:@"Pace:(%lds)", model.quant_data.averageTime];
	self.exerciseTimeView.progress = model.quant_data.averageTime / 60.0;
    CGFloat modelHeight = circelViewHeight;
    [model ht_setRowHeightNumber:@(modelHeight) forCellClass:self.class];
}

- (HTReportExerciseCircleView *)rightPercentView {
	if (!_rightPercentView) {
		_rightPercentView = [[HTReportExerciseCircleView alloc] initWithFrame:CGRectMake((HTSCREENWIDTH - 160 * 2) / 3.0, 0, 160, 170)];
		_rightPercentView.tintColor = [UIColor ht_colorStyle:HTColorStylePrimaryTheme];
	}
	return _rightPercentView;
}

- (HTReportExerciseCircleView *)exerciseTimeView {
	if (!_exerciseTimeView) {
		_exerciseTimeView = [[HTReportExerciseCircleView alloc] initWithFrame:CGRectMake((HTSCREENWIDTH - 160 * 2) / 3.0 * 2 + 160, 0, 160, 170)];
		_exerciseTimeView.tintColor = [UIColor orangeColor];
	}
	return _exerciseTimeView;
}

@end
