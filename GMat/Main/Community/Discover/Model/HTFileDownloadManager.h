//
//  HTFileDownloadManager.h
//  GMat
//
//  Created by hublot on 2017/6/28.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTFileDownloadModel.h"

@interface HTFileDownloadManager : NSObject

+ (NSString *)filePathWithSaveFileName:(NSString *)saveFileName;

+ (void)startDownloadFileUrlString:(NSString *)url saveFileName:(NSString *)saveFileName;

+ (void)deleteDownloadFileUrlSaveFileName:(NSString *)saveFileName;

+ (NSArray <HTFileDownloadModel *> *)packDownloadingModelArray;

+ (NSArray <HTFileDownloadModel *> *)packDownloadCompleteModelArray;

@end
