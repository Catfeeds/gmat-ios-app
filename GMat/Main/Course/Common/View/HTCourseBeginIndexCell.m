//
//  HTCourseBeginIndexCell.m
//  GMat
//
//  Created by hublot on 2017/4/19.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTCourseBeginIndexCell.h"
#import "HTCourseBeginView.h"
#import "HTCourseBeginModel.h"
#import "HTWebController.h"
#import "HTRandomNumberManager.h"
#import "HTLoginManager.h"
#import "HTUserManager.h"
#import <NSObject+HTTableRowHeight.h>
#import "HTManagerController.h"
#import "HTPlayerController.h"

@interface HTCourseBeginIndexCell ()

@property (nonatomic, strong) NSMutableArray <HTCourseBeginView *> *courseBeginCellArray;

@end

@implementation HTCourseBeginIndexCell

- (void)didMoveToSuperview {
	CGFloat itemHeight = 130;
	CGFloat itemWidth = (HTSCREENWIDTH - 10 - 10 - 10) * 0.5;
	[self.courseBeginCellArray enumerateObjectsUsingBlock:^(HTCourseBeginView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		CGRect frame = CGRectMake(10 + (itemWidth + 10) * (idx % 2), (itemHeight + 10) * (idx / 2), itemWidth, itemHeight);
		frame.origin.y += 10;
		obj.frame = frame;
		[self addSubview:obj];
	}];
}

- (void)setModel:(id)model row:(NSInteger)row {
    CGFloat rowHeight = 10 + 130 + 10 + 130 + 10;
    [model ht_setRowHeightNumber:@(rowHeight) forCellClass:self.class];
	
	NSArray *modelArray = model;
	[self.courseBeginCellArray enumerateObjectsUsingBlock:^(HTCourseBeginView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		HTCourseBeginModel *beginModel = modelArray[idx];
		[obj setModel:beginModel row:idx];
		
		__weak HTCourseBeginView *weakObj = obj;
		[obj ht_whenTap:^(UIView *view) {
			void(^complete)(void) = ^() {
				//				NSString *identifier = [NSString stringWithFormat:@"%@%ld", NSStringFromClass([HTCourseBeginModel class]), idx];
				//				[HTRandomNumberManager ht_randomAppendWithIdentifier:identifier appendCount:1];
				beginModel.playTimes += 1;
				[weakObj setModel:beginModel row:idx];
				
				HTPlayerController *playerController = [[HTPlayerController alloc] init];
				playerController.courseModel = beginModel;
				[self.ht_controller.navigationController pushViewController:playerController animated:true];
			};
			if ([HTManagerController defaultManagerController].managerModel.isAppStoreOnReviewingVersion) {
				complete();
			} else {
				if ([HTUserManager currentUser].permission < HTUserPermissionExerciseAbleUser) {
					[HTLoginManager presentAndLoginSuccess:complete];
				} else {
					complete();
				}
			}
		}];
	}];
}

- (NSMutableArray<HTCourseBeginView *> *)courseBeginCellArray {
	if (!_courseBeginCellArray) {
		_courseBeginCellArray = [@[] mutableCopy];
		for (NSInteger index = 0; index < 4; index ++) {
			HTCourseBeginView *courseBeginView = [[HTCourseBeginView alloc] init];
			[_courseBeginCellArray addObject:courseBeginView];
		}
	}
	return _courseBeginCellArray;
}

@end
