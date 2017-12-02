//
//  HTScoreModel.m
//  GMat
//
//  Created by hublot on 2016/11/11.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTScoreModel.h"

@implementation HTScoreModel

+ (NSDictionary *)objectClassInArray{
    return @{@"questionrecord" : [MockScoreQuestionrecord class]};
}

@end


@implementation MockScoreS

@end


@implementation MockScoreSc

@end


@implementation MockScoreRc

@end


@implementation MockScoreCr

@end


@implementation MockScorePs

@end


@implementation MockScoreDs

@end


@implementation MockScoreMkinfo

@end


@implementation MockScoreCredit

@end


@implementation MockScoreQuestionrecord

+ (NSDictionary *)objectClassInArray{
    return @{@"qslctarr" : [MockScoreQslctarr class]};
}

@end


@implementation MockScoreQanswer

@end


@implementation MockScoreParse

@end


@implementation MockScoreQslctarr

@end


