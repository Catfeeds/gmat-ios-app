//
//  HTQuestionModel.m
//  GMat
//
//  Created by hublot on 2016/11/9.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTGroupQuestionModel.h"

@implementation HTGroupQuestionModel

- (void)dealloc {
    
}

+ (void)load {
	[self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
		return @{@"Do":@"do"};
	}];
}

@end


@implementation HTQuestionContentData

+ (NSDictionary *)objectClassInArray{
    return @{@"qslctarr" : [HTQuestionSelectedQslctarr class]};
}

@end


@implementation HTQuestionSelectedQslctarr

@end


