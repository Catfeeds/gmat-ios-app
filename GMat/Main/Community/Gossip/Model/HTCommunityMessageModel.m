//
//  HTCommunityMessageModel.m
//  GMat
//
//  Created by hublot on 2016/11/23.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTCommunityMessageModel.h"

@implementation HTCommunityMessageModel

+ (void)load {
	[self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
		return @{@"Id":@"id"};
	}];
}

@end


@implementation HTLiveMessageModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
	return @{
			 @"Id" : @"id",
			 };
}

@end
