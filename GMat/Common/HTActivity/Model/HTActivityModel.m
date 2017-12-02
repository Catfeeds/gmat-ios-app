//
//  HTActivityModel.m
//  GMat
//
//  Created by hublot on 2017/8/24.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTActivityModel.h"

@implementation HTActivityModel

+ (void)load {
	[self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
		return @{@"ID":@"id"};
	}];
}

@end
