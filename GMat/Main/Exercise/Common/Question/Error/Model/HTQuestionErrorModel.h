//
//  HTQuestionErrorModel.h
//  GMat
//
//  Created by hublot on 2017/8/23.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HTQuestionErrorType) {
	HTQuestionErrorTypeAnswer,
	HTQuestionErrorTypeStyle,
	HTQuestionErrorTypeContent,
	HTQuestionErrorTypeOther,
};

@interface HTQuestionErrorModel : NSObject

@property (nonatomic, strong) NSString *titleName;

@property (nonatomic, assign) BOOL isSelected;

+ (NSArray *)packModelArray;

@end
