//
//  HTContactUsModel.h
//  GMat
//
//  Created by hublot on 2016/10/25.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTContactUsModel : NSObject

@property (nonatomic, strong) NSString *titleName;

@property (nonatomic, strong) NSString *headerTitle;

+ (NSArray <HTContactUsModel *> *)packModelArray;

@end
