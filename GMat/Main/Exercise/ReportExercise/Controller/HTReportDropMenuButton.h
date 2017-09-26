//
//  HTReportDropMenuButton.h
//  GMat
//
//  Created by hublot on 16/11/30.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTReportDropMenuButton : UIButton

@property (nonatomic, assign) NSInteger selecteIndex;

- (instancetype)initWithTitleArray:(NSArray <NSString *> *)titleArray selectedBlock:(void(^)(NSInteger index))selectedBlock;

@end
