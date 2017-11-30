//
//  HTExerciseHeaderView.m
//  GMat
//
//  Created by hublot on 2017/5/17.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTExerciseHeaderView.h"

@interface HTExerciseHeaderView ()

@end

@implementation HTExerciseHeaderView

- (void)didMoveToSuperview {
	[self setModel:nil row:0];
	[self addSubview:self.exerciseCountView];
	[self addSubview:self.exerciseSearchView];
	[self.exerciseCountView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self);
		make.right.mas_equalTo(self);
		make.top.mas_equalTo(self);
		make.bottom.mas_equalTo(self.exerciseSearchView.mas_top);
	}];
	[self.exerciseSearchView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self);
		make.right.mas_equalTo(self);
		make.height.mas_equalTo(110);
		make.bottom.mas_equalTo(self);
	}];
}

- (void)setModel:(id)model row:(NSInteger)row {
	[self.exerciseSearchView setModel:model row:row];
}

- (HTExerciseCountView *)exerciseCountView {
	if (!_exerciseCountView) {
		_exerciseCountView = [[HTExerciseCountView alloc] init];
	}
	return _exerciseCountView;
}

- (HTExerciseSearchView *)exerciseSearchView {
	if (!_exerciseSearchView) {
		_exerciseSearchView = [[HTExerciseSearchView alloc] init];
	}
	return _exerciseSearchView;
}

@end
