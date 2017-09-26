//
//  HTQuestionParseModel.h
//  GMat
//
//  Created by hublot on 2017/3/11.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTQuestionParseModel : NSObject

@property (nonatomic, strong) NSString *parseSendOwner;

@property (nonatomic, strong) NSDate *parseSendDate;

@property (nonatomic, strong) NSString *parseDetailContent;

@property (nonatomic, strong) NSAttributedString *parseContentAttributedString;

@end
