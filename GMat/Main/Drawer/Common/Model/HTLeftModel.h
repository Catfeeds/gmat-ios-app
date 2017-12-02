//
//  HTLeftModel.h
//  GMat
//
//  Created by hublot on 2016/10/21.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTLeftModel : NSObject

@property (nonatomic, strong) NSString *titleName;

@property (nonatomic, assign) Class controllerClass;

+ (NSArray <HTLeftModel *> *)packModelArray;

@end
