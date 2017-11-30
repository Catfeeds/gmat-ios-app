//
//  HTFileDownloadModel.h
//  GMat
//
//  Created by hublot on 2017/6/28.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTFileDownloadModel : NSObject

@property (nonatomic, strong) NSString *fileTitleName;

@property (nonatomic, assign) CGFloat completedMegaByte;

@property (nonatomic, assign) CGFloat totalMegaByte;

@property (nonatomic, strong) NSURLSessionTask *task;


@property (nonatomic, assign) BOOL selected;



@property (nonatomic, copy) void(^selectedObserver)(BOOL selected);

@property (nonatomic, copy) void(^downloadComplete)(void);

@end
