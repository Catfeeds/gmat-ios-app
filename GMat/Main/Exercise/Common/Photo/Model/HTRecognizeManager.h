//
//  HTRecognizeManager.h
//  GMat
//
//  Created by hublot on 2017/3/29.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTRecognizeManager : NSObject

+ (void)recognizeImage:(UIImage *)image complte:(void(^)(NSString *recognizeString))complte;

@end
