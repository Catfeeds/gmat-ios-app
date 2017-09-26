//
//  NSTimer+HTBackground.m
//  GMat
//
//  Created by hublot on 2017/8/3.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "NSTimer+HTBackground.h"
#import <NSObject+HTObjectCategory.h>


typedef void(^timerBlockName)(NSTimer *timer);

@interface HTTimerModel : NSObject

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSTimeInterval timeInterval;

@property (nonatomic, copy) timerBlockName timerBlock;

@end


@implementation HTTimerModel

@end



@interface HTTimerManager : NSObject

+ (instancetype)defaultManager;

@end

@interface HTTimerManager ()

@property (nonatomic, strong) NSMutableArray <HTTimerModel *> *timerModelArray;

@end


@implementation HTTimerManager

static HTTimerManager *timerManager;

static NSDate *kHTLastDidEnterBackgroundDate;

+ (instancetype)defaultManager {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		timerManager = [[HTTimerManager alloc] init];
		[[NSNotificationCenter defaultCenter] addObserver:timerManager selector:@selector(didEnterBackgroundNotifacation) name:UIApplicationDidEnterBackgroundNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:timerManager selector:@selector(willEnterForegroundNotication) name:UIApplicationWillEnterForegroundNotification object:nil];
	});
	return timerManager;
}

- (void)append:(NSTimer *)timer timeInterval:(NSTimeInterval)timeInterval block:(timerBlockName)block {
	HTTimerModel *timerModel = [[HTTimerModel alloc] init];
	timerModel.timer = timer;
	timerModel.timeInterval = timeInterval;
	timerModel.timerBlock = block;
	if (!self.timerModelArray) {
		self.timerModelArray = [@[] mutableCopy];
	}
	[self.timerModelArray addObject:timerModel];
}

- (void)remove:(NSTimer *)timer {
	NSMutableArray *forEachModelArray = [self.timerModelArray mutableCopy];
	[forEachModelArray enumerateObjectsUsingBlock:^(HTTimerModel *model, NSUInteger index, BOOL * _Nonnull stop) {
		if (model.timer == timer) {
			[self.timerModelArray removeObject:model];
		}
	}];
}

- (void)didEnterBackgroundNotifacation {
	kHTLastDidEnterBackgroundDate = [NSDate date];
}

- (void)willEnterForegroundNotication {
	if (kHTLastDidEnterBackgroundDate == nil) {
		return;
	}
	NSDate *date = [NSDate date];
	NSTimeInterval distance = MAX(0, date.timeIntervalSince1970 - kHTLastDidEnterBackgroundDate.timeIntervalSince1970);
	[self.timerModelArray enumerateObjectsUsingBlock:^(HTTimerModel *timerModel, NSUInteger index, BOOL * _Nonnull stop) {
		NSInteger count = (NSInteger)distance / (NSInteger)timerModel.timeInterval;
		if (timerModel.timerBlock) {
			@try {
				for (NSInteger index = 0; index < count; index ++) {
					timerModel.timerBlock(timerModel.timer);
				}
			} @catch (NSException *exception) {
				
			} @finally {
				
			}
		}
	}];
	kHTLastDidEnterBackgroundDate = nil;
}

@end


















@interface NSTimer ()

- (void)ht_executeBlockFromTimer:(NSTimer *)timer;

@end

@implementation NSTimer (HTBackground)

+ (void)load {
	[self ht_swizzInstanceNativeSelector:NSSelectorFromString(@"dealloc") customSelector:@selector(ht_dealloc)];
}



+ (instancetype)ht_scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)(NSTimer *timer))block repeats:(BOOL)inRepeats {
	NSParameterAssert(block != nil);
	id target = self;
	SEL selector = @selector(ht_executeBlockFromTimer:);
	NSTimer *timer = [self scheduledTimerWithTimeInterval:inTimeInterval target:target selector:selector userInfo:[block copy] repeats:inRepeats];
	[[HTTimerManager defaultManager] append:timer timeInterval:inTimeInterval block:block];
	return timer;
}

+ (void)ht_executeBlockFromTimer:(NSTimer *)aTimer {
	void (^block)(NSTimer *) = [aTimer userInfo];
	if (block) block(aTimer);
}




+ (NSTimer *)ht_scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo {
	NSTimer *timer = [self ht_scheduledTimerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
	
	// UIApplicationSignificantTimeChangeNotification 忽略了时间可能会被用户更改
	// beginBackgroundTaskWithExpirationHandler 这个方法最多申请三分钟, 如果三分钟后不调用 endBackgroundTask, 应用会被 kill (必须 release 才能复现)
	
	
	return timer;
}

- (void)ht_dealloc {
	[self ht_dealloc];
	[[HTTimerManager defaultManager] remove:self];
	
}

@end
