//
//  HTMessageModel.h
//  GMat
//
//  Created by hublot on 16/11/7.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTMessageModel : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *time;

@end
