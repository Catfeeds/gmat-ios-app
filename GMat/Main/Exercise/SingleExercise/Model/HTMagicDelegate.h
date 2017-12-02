//
//  HTMagicDelegate.h
//  GMat
//
//  Created by hublot on 2016/10/31.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTMagicView.h"

@interface HTMagicDelegate : NSObject <VTMagicViewDataSource, VTMagicViewDelegate>

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, assign) NSInteger selectedIndex;

- (instancetype)initWithTitleArray:(NSArray *)titleArray menuItemBlock:(UIButton *(^)(VTMagicView *magicView, NSUInteger itemIndex))menuItemBlock didSelectedBlock:(void(^)(VTMagicView *magicView, NSUInteger itemIndex))didSelectedBlock;

@end
