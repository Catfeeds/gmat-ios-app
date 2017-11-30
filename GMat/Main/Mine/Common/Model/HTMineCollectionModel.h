//
//  HTMineCollectionModel.h
//  GMat
//
//  Created by hublot on 2016/10/19.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTMineCollectionModel : NSObject

@property (nonatomic, strong) NSString *titleName;

@property (nonatomic, strong) NSString *imageName;

@property (nonatomic, assign) Class controllerClass;

+ (NSArray <HTMineCollectionModel *> *)packModelArray;

@end
