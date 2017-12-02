//
//  HTCommunityModel.m
//  GMat
//
//  Created by hublot on 2016/11/22.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTCommunityModel.h"

@implementation HTCommunityModel

+ (void)load {
	[self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
		return @{@"Id":@"id"};
	}];
}


+ (NSDictionary *)objectClassInArray{
    return @{@"reply" : [CommunityReply class]};
}

- (void)mj_keyValuesDidFinishConvertingToObject {
}

@end

@implementation CommunityReply

+ (void)load {
	[self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
		return @{@"Id":@"id"};
	}];
}

+ (NSDictionary *)objectClassInArray{
	return @{@"asked" : [CommunityReply class]};
}

@end


