//
//  HTPlayerModel.h
//  GMat
//
//  Created by hublot on 2017/9/25.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTPlayerDocumentModel.h"

@interface HTPlayerModel : NSObject

@property (nonatomic, copy, readonly) NSString *m3u8URLString;

@property (nonatomic, copy, readonly) NSArray <HTPlayerDocumentModel *> *documentModelArray;

- (instancetype)initWithXMLDictionary:(NSDictionary *)dictionary xmlURLString:(NSString *)xmlURLString;


// 外部设置, 会影响到自己的 currentDocumentModel 改变
@property (nonatomic, assign) CGFloat currentTime;

// 这个改变, 外部 Observer 变化
@property (nonatomic, strong) HTPlayerDocumentModel *currentDocumentModel;

@end
