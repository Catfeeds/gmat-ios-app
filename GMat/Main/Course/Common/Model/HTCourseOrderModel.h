//
//  HTCourseOrderModel.h
//  GMat
//
//  Created by hublot on 2016/11/16.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTCourseOnlineVideoModel.h"

@interface HTCourseOrderModel : NSObject

@property (nonatomic, copy) NSString *order_id;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *order_status;

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, copy) NSString *num;

@property (nonatomic, strong) HTCourseOnlineVideoModel *data;

@end
