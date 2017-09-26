//
//  NSTimer+HTBackground.h
//  GMat
//
//  Created by hublot on 2017/8/3.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (HTBackground)

+ (instancetype)ht_scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)(NSTimer *timer))block repeats:(BOOL)inRepeats;

@end
