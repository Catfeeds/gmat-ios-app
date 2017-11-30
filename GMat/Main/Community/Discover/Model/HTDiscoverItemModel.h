//
//  HTDiscoverItemModel.h
//  GMat
//
//  Created by hublot on 2017/7/4.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HTDiscoverItemType) {
	HTDiscoverItemTypeTime,
	HTDiscoverItemTypeAddress,
	HTDiscoverItemTypeContent,
	HTDiscoverItemTypeStep,
	HTDiscoverItemTypeMoney,
	HTDiscoverItemTypeIssue,
	HTDiscoverItemTypeCard,
	HTDiscoverItemTypeExit,
	HTDiscoverItemTypeScore,
};

@interface HTDiscoverItemModel : NSObject

@property (nonatomic, assign) HTDiscoverItemType type;

@property (nonatomic, strong) NSString *itemId;

@property (nonatomic, strong) NSString *titleName;

@property (nonatomic, strong) NSString *imageName;

+ (NSArray  <HTDiscoverItemModel *> *)packModelArray;

@end
