//
//  HTAppStoreStarManager.h
//  GMat
//
//  Created by hublot on 2017/8/3.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTAppStoreStarManager : NSObject

+ (instancetype)defaultManager;

- (void)startMonitoringShouldAppStoreStar;

@end
