//
//  HTSqliteUpdateManager.h
//  GMat
//
//  Created by hublot on 2017/8/22.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTSqliteUpdateManager : NSObject

+ (void)valiteSqliteUpdateComplete:(void(^)(BOOL show))complete;

@end
