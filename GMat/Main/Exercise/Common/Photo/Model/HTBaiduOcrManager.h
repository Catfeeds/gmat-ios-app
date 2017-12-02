//
//  HTBaiduOcrManager.h
//  GMat
//
//  Created by hublot on 2017/4/5.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTBaiduOcrManager : NSObject

+ (void)requestWithImage:(UIImage *)image complete:(void(^)(NSString *recognizeString))complete;

@end
