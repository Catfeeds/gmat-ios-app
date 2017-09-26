//
//  HTPreviewController.h
//  GMat
//
//  Created by hublot on 2017/6/29.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <QuickLook/QuickLook.h>

@interface HTPreviewController : QLPreviewController

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSArray <NSString *> *filePathArray;

@end
