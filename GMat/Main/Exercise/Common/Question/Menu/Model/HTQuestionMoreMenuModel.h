//
//  HTQuestionMoreMenuModel.h
//  GMat
//
//  Created by hublot on 2017/8/23.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HTQuestionMoreItemType) {
	HTQuestionMoreItemTypeParse,
	HTQuestionMoreItemTypeFont,
	HTQuestionMoreItemTypeError,
};

@interface HTQuestionMoreMenuModel : NSObject

@property (nonatomic, assign) HTQuestionMoreItemType type;

@property (nonatomic, assign) BOOL isHidden;

@property (nonatomic, strong) NSString *titleName;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, strong) NSString *selectedTitle;

+ (NSArray <HTQuestionMoreMenuModel *> *)packModelArray;

@end
