//
//  HTCourseTryListenIndexCell.m
//  GMat
//
//  Created by hublot on 17/4/18.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTCourseTryListenIndexCell.h"
#import "HTCourseTryListenView.h"
#import "HTTryListenModel.h"
#import "HTTryListenWebController.h"
#import "HTRandomNumberManager.h"
#import "HTUserManager.h"
#import "HTLoginManager.h"
#import <NSObject+HTTableRowHeight.h>
#import "HTManagerController.h"
#import "HTPlayerController.h"

@interface HTCourseTryListenIndexCell ()

@property (nonatomic, strong) NSMutableArray <HTCourseTryListenView *> *tryListenCellArray;

@end

@implementation HTCourseTryListenIndexCell

- (void)didMoveToSuperview {
	CGFloat itemHeight = 140;
	CGFloat maxItemWidth = (HTSCREENWIDTH - 10 - 10 - 10) * 0.55;
	CGFloat minItemWidth = (HTSCREENWIDTH - 10 - 10 - 10) * 0.45;
	[self.tryListenCellArray enumerateObjectsUsingBlock:^(HTCourseTryListenView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		CGRect frame = CGRectZero;
		if (idx == 0) {
			frame = CGRectMake(10, 10, maxItemWidth, itemHeight);
		} else if (idx == 1) {
			frame = CGRectMake(maxItemWidth + 10 + 10, 10, minItemWidth, itemHeight);
		} else if (idx == 2) {
			frame = CGRectMake(10, 10 + 10 + itemHeight, minItemWidth, itemHeight);
		} else {
			frame = CGRectMake(minItemWidth + 10 + 10, 10 + 10 + itemHeight, maxItemWidth, itemHeight);
		}
		obj.frame = frame;
		[self addSubview:obj];
	}];
    
}

- (void)setModel:(id)model row:(NSInteger)row {
    CGFloat modelHeight = 10 + 140 + 10 + 140 + 10;
    [model ht_setRowHeightNumber:@(modelHeight) forCellClass:self.class];
	
	NSArray *modelArray = model;
	[self.tryListenCellArray enumerateObjectsUsingBlock:^(HTCourseTryListenView *tryListenView, NSUInteger index, BOOL * _Nonnull stop) {
		HTTryListenModel *tryListenModel = modelArray[index];
		[tryListenView setModel:tryListenModel row:index];
		
		__weak HTCourseTryListenView *weakTryListenView = tryListenView;
		[tryListenView ht_whenTap:^(UIView *view) {
			void(^complete)(void) = ^() {
				//				NSString *identifier = [NSString stringWithFormat:@"%@%ld", NSStringFromClass([HTTryListenModel class]), index];
				//				[HTRandomNumberManager ht_randomAppendWithIdentifier:identifier appendCount:1];
				tryListenModel.playTimes += 1;
				[weakTryListenView setModel:tryListenModel row:index];
				
//				HTTryListenWebController *webController = [[HTTryListenWebController alloc] initWithAddress:tryListenModel.webHtmlUrlString];
//				[self.ht_controller.navigationController pushViewController:webController animated:true];
				
				HTPlayerController *playerController = [[HTPlayerController alloc] init];
				playerController.courseModel = tryListenModel;
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

- (NSMutableArray<HTCourseTryListenView *> *)tryListenCellArray {
	if (!_tryListenCellArray) {
		_tryListenCellArray = [@[] mutableCopy];
		for (NSInteger index = 0; index < 4; index ++) {
			HTCourseTryListenView *tryListenView = [[HTCourseTryListenView alloc] init];
			[_tryListenCellArray addObject:tryListenView];
		}
	}
	return _tryListenCellArray;
}

@end
