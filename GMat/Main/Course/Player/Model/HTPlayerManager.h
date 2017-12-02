//
//  HTPlayerManager.h
//  GMat
//
//  Created by hublot on 2017/9/25.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTPlayerModel.h"

@interface HTPlayerManager : NSObject

+ (void)findPlayerXMLURLFromCourseURLString:(NSString *)courseURLString complete:(void(^)(NSString *playerXMLString))complete;

+ (void)findM3U8URLFromXMLURLString:(NSString *)XMLURLString complete:(void(^)(HTPlayerModel *model))complete;

@end
