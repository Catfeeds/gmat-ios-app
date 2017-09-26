//
//  HTAppStoreStarManager.m
//  GMat
//
//  Created by hublot on 2017/8/3.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTAppStoreStarManager.h"
#import "HTAppStoreStarView.h"
#import "HTManagerController.h"
#import "HTUserActionManager.h"

@implementation HTAppStoreStarManager

+ (instancetype)defaultManager {
	static HTAppStoreStarManager *startManager;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		startManager = [[HTAppStoreStarManager alloc] init];
	});
	return startManager;
}

- (void)startMonitoringShouldAppStoreStar {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkShouldOpenAppStoreStarView) name:kHTUserActionAppendNotification object:nil];
}

- (void)checkShouldOpenAppStoreStarView {
	if ([self shouldOpenAppStoreStarView]) {
		[HTAppStoreStarView showWithAnimted:true superView:[HTManagerController defaultManagerController].view];
	}
}

- (BOOL)shouldOpenAppStoreStarView {
	__block BOOL should = false;
	NSInteger questionCount = [HTUserActionManager trackCountForType:HTUserActionTypeCompleteSingleQuestion];
	NSArray *questionStandardArray = @[@(100), @(500), @(1000)];
	[questionStandardArray enumerateObjectsUsingBlock:^(NSNumber *number, NSUInteger index, BOOL * _Nonnull stop) {
		if (questionCount == number.integerValue) {
			should = true;
		}
	}];
	
	NSInteger mockCount = [HTUserActionManager trackCountForType:HTUserActionTypeCompleteSingleMock];
	NSArray *mockStandardArray = @[@(5), @(10)];
	[mockStandardArray enumerateObjectsUsingBlock:^(NSNumber *number, NSUInteger index, BOOL * _Nonnull stop) {
		if (mockCount == number.integerValue) {
			should = true;
		}
	}];
	
	return should;
}

@end
