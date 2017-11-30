//
//  HTPlayerSpeedModel.h
//  GMat
//
//  Created by hublot on 2017/9/28.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTPlayerSpeedModel : NSObject

@property (nonatomic, strong) NSString *titleName;

@property (nonatomic, assign) CGFloat rate;

@property (nonatomic, assign) BOOL isSelected;

+ (NSArray *)packModelArray;

@end
