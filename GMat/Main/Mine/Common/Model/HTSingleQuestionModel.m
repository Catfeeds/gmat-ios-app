//
//  HTSingleQuestionModel.m
//  GMat
//
//  Created by hublot on 2016/11/18.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTSingleQuestionModel.h"

@implementation HTSingleQuestionModel

+ (NSDictionary *)objectClassInArray{
    return @{@"sameknow" : [SingleQuestionSameknow class], @"parseall" : [SingleQuestionParseall class]};
}

@end


@implementation SingleQuestionQuestion

+ (NSDictionary *)objectClassInArray{
    return @{@"qslctarr" : [SingleQuestionQslctarr class], @"questionknowsid" : [SingleQuestionQuestionknowsid class]};
}

@end


@implementation SingleQuestionQanswer

@end


@implementation SingleQuestionQslctarr

@end


@implementation SingleQuestionQuestionknowsid

@end


@implementation SingleQuestionPars_Audit

@end


@implementation SingleQuestionSameknow

@end


@implementation SingleQuestionParseall

@end


