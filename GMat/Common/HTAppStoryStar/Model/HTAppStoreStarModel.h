//
//  HTAppStoreStarModel.h
//  GMat
//
//  Created by hublot on 2017/8/4.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HTAppStoreStarType) {
	HTAppStoreStarTypeGood,
	HTAppStoreStarTypeIssue,
	HTAppStoreStarTypeReject
};

@interface HTAppStoreStarModel : NSObject

@property (nonatomic, assign) HTAppStoreStarType type;

@property (nonatomic, strong) NSString *titleName;

@property (nonatomic, strong) UIColor *titleColor;

+ (NSArray <HTAppStoreStarModel *> *)packModelArray;

@end
