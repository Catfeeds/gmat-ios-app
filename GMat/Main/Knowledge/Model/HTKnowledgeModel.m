//
//  HTKnowledgeModel.m
//  GMat
//
//  Created by hublot on 16/10/12.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTKnowledgeModel.h"

@implementation HTKnowledgeModel

+ (NSDictionary *)objectClassInArray{
    return @{@"categoryType" : [KnowledgeCategorytype class]};
}
@end
@implementation KnowledgeCategorytype

+ (NSDictionary *)objectClassInArray{
    return @{@"categoryContent" : [KnowledgeCategorycontent class]};
}

@end


@implementation KnowledgeCategorycontent

@end


