//
//  HTUpdateModel.m
//  GMat
//
//  Created by hublot on 2016/12/22.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTUpdateModel.h"

@implementation HTUpdateModel




+ (NSDictionary *)objectClassInArray{
    return @{@"results" : [UpdateResults class]};
}
@end
@implementation UpdateResults

+ (void)load {
	[self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
		return @{@"Description":@"description"};
	}];
}

@end


